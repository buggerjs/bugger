'use strict';

function ObjectGroup(name) {
  this.name = name;
  this.release();
}
module.exports = ObjectGroup;

ObjectGroup.prototype.release = function release() {
  this.refs = Object.create(null);
  this.lastId = 0;
};

ObjectGroup.prototype._createObjectMirror =
function _createObjectMirror(value) {
  if (value === null) {
    return { type: 'object', subtype: 'null' };
  }

  return this._cached(value, createRemoteObject);
};

ObjectGroup.prototype._createFunctionMirror =
function _createFunctionMirror(value) {
  return this._cached(value, createRemoteFunction);
};

ObjectGroup.prototype._cached =
function _cached(value, presenter) {
  var objectId;
  for (objectId in this.refs) {
    if (this.refs[objectId] === value) {
      return presenter(objectId, value);
    }
  }

  objectId = 'mirror:' + this.name + ':' + (++this.lastId);
  this.refs[objectId] = value;
  return presenter(objectId, value);
};

ObjectGroup.prototype.add =
function add(value) {
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
  }
  console.log('TODO: Store %j in group %j', typeof value, this.name);
  throw new Error('Not implemented: ' + typeof value);
};

var _groups = {};

ObjectGroup.releaseObjectGroup =
function releaseObjectGroup(objectGroup) {
  var group = _groups[objectGroup];
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
  var parts = objectId.split(':');
  var objectGroup = parts[1];
  return {
    objectGroup: objectGroup,
    value: _groups[objectGroup].refs[objectId]
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
    return remoteObject.value;

  default:
    throw new Error(`Unknown remote object type: ${remoteObject.type}`);
  }
}
ObjectGroup.revive = reviveRemoteObject;

function getRemoteObjectClassName(object) {
  if (object.constructor && object.constructor.name) {
    return object.constructor.name;
  }
  var str = Object.prototype.toString.apply(object);
  return str.replace(/^\[object (.+)\]$/, '$1');
}

function createRemoteObject(objectId, value) {
  var className = getRemoteObjectClassName(value);
  var description = className;
  var subtype;
  if (Array.isArray(value) || Buffer.isBuffer(value)) {
    subtype = 'array';
    description += '[' + value.length + ']';
  }
  return {
    type: 'object',
    subtype: subtype,
    objectId: objectId,
    className: className,
    description: description
  };
}

function createRemoteFunction(objectId, value) {
  return {
    type: 'function',
    objectId: objectId,
    description: value.toString()
  };
}
