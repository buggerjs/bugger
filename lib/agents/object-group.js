'use strict';

function getRemoteObjectClassName(object) {
  if (object.constructor && object.constructor.name) {
    return object.constructor.name;
  }
  const str = Object.prototype.toString.apply(object);
  return str.replace(/^\[object (.+)\]$/, '$1');
}

function createRemoteObject(objectId, value) {
  const className = getRemoteObjectClassName(value);
  let description = className;
  let subtype;
  if (Array.isArray(value) || Buffer.isBuffer(value)) {
    subtype = 'array';
    description += '[' + value.length + ']';
  }
  return {
    type: 'object',
    subtype: subtype,
    objectId: objectId,
    className: className,
    description: description,
  };
}

function createRemoteFunction(objectId, value) {
  return {
    type: 'function',
    objectId: objectId,
    description: value.toString(),
  };
}

class ObjectGroup {
  constructor(name) {
    this.name = name;
    this.release();
  }

  release() {
    this.refs = Object.create(null);
    this.lastId = 0;
  }

  _createObjectMirror(value) {
    if (value === null) {
      return { type: 'object', subtype: 'null' };
    }

    return this._cached(value, createRemoteObject);
  }

  _createFunctionMirror(value) {
    return this._cached(value, createRemoteFunction);
  }

  _cached(value, presenter) {
    let objectId;
    for (objectId in this.refs) {
      if (this.refs[objectId] === value) {
        return presenter(objectId, value);
      }
    }

    objectId = 'mirror:' + this.name + ':' + (++this.lastId);
    this.refs[objectId] = value;
    return presenter(objectId, value);
  }

  add(value) {
    switch (typeof value) {
    case 'undefined':
    case 'string':
    case 'number':
    case 'boolean':
      return { type: typeof value, value: value };

    case 'function':
      return this._createFunctionMirror(value);

    case 'object':
      return this._createObjectMirror(value);

    default:
      /* eslint no-console: 0 */
      console.log('TODO: Store %j in group %j', typeof value, this.name);
      throw new Error('Not implemented: ' + typeof value);
    }
  }
}
module.exports = ObjectGroup;

const _groups = {};

ObjectGroup.releaseObjectGroup =
function releaseObjectGroup(objectGroup) {
  const group = _groups[objectGroup];
  if (group) {
    group.release();
    delete _groups[objectGroup];
  }
};

ObjectGroup.add =
function addToObjectGroup(objectGroup, value) {
  if (!_groups[objectGroup]) {
    _groups[objectGroup] = new ObjectGroup(objectGroup);
  }
  return _groups[objectGroup].add(value);
};

function parseAndGetByObjectId(objectId) {
  const parts = objectId.split(':');
  const objectGroup = parts[1];
  const group = _groups[objectGroup];
  if (!group) {
    throw new Error(`Could not find ObjectGroup ${objectGroup} for ${objectId}`);
  }
  return {
    objectGroup: objectGroup,
    value: group.refs[objectId],
  };
}
ObjectGroup.parseAndGet = parseAndGetByObjectId;

function getByObjectId(objectId) {
  return parseAndGetByObjectId(objectId).value;
}
ObjectGroup.get = getByObjectId;

function reviveRemoteObject(remoteObject) {
  switch (remoteObject.type) {
  case 'undefined':
  case 'string':
  case 'number':
  case 'boolean':
  case undefined:
    return remoteObject.value;

  default:
    throw new Error(`Unknown remote object type: ${remoteObject.type}`);
  }
}
ObjectGroup.revive = reviveRemoteObject;
