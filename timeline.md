## The Timeline Tab

This documents tries to capture what data is shown in the timeline tab.

##### References

* [Trace Event Format](https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/preview)

### Duration Events

#### MajorGC / MinorGC

Tracks time spent in GC.

##### Arguments

* `usedHeapSizeBefore`: *B only* Heap size before GC started.
* `usedHeapSizeAfter`: *E only* Heap size after GC finished.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923138261202,
  "ph": "B",
  "cat": "devtools.timeline,v8",
  "name": "MinorGC",
  "args": {
    "usedHeapSizeBefore": 21120128
  },
  "tts": 2617238
}
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923138265640,
  "ph": "E",
  "cat": "devtools.timeline,v8",
  "name": "MinorGC",
  "args": {
    "usedHeapSizeAfter": 19648456
  },
  "tts": 2621423
}
```

### Complete Events

#### FunctionCall

Best guess: These are emitted whenever native code calls into JS-land.
In blink this is handled via `V8ScriptRunner::callFunction`.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923135876376,
  "ph": "X",
  "cat": "devtools.timeline,v8",
  "name": "FunctionCall",
  "args": {
    "data": {
      "scriptId": "142",
      "scriptName": "https://assets-cdn.github.com/assets/github-37bdbe413b8d63eb404649438916711bf73507e197a30398097bc716eaec7784.js",
      "scriptLine": 5,
      "frame": "0x1bb474a68240",
      "stackTrace": [
        {
          "functionName": "a.onopen",
          "scriptId": "142",
          "url": "https://assets-cdn.github.com/assets/github-37bdbe413b8d63eb404649438916711bf73507e197a30398097bc716eaec7784.js",
          "lineNumber": 5,
          "columnNumber": 20099
        }
      ]
    }
  },
  "dur": 61,
  "tdur": 53,
  "tts": 2521500
}
```

### Instant Events

#### TracingStartedInPage

The very first trace event emitted.

##### Arguments

* `sessionId`: A unique id for the new tracing session.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923133809586,
  "ph": "I",
  "cat": "disabled-by-default-devtools.timeline",
  "name": "TracingStartedInPage",
  "args": {
    "data": {
      "sessionId": "46308.8",
      "page": "0x1bb474a68240"
    }
  },
  "tts": 1737318,
  "s": "t"
}
```

#### UpdateCounters

The counters are updated and emitted "whenever something interesting happens".
Maybe they are planning on using counter events for this in future..?

##### Arguments

* `data`: A map of counter name to value.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923138992351,
  "ph": "I",
  "cat": "disabled-by-default-devtools.timeline",
  "name": "UpdateCounters",
  "args": {
    "data": {
      "documents": 6,
      "nodes": 9031,
      "jsEventListeners": 31,
      "jsHeapSizeUsed": 15926104
    }
  },
  "tts": 2658770,
  "s": "t"
}
```

#### ResourceSendRequest

##### Arguments

* `data.requestId`: Identifier of the request.
* `data.frame`: Identifier of the frame.
* `data.url`: Url of the resource being requested.
* `data.requestMethod`: HTTP method, e.g. 'POST' or 'GET'.
* `data.stackTrace`: Originator of the request.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923137172974,
  "ph": "I",
  "cat": "devtools.timeline",
  "name": "ResourceSendRequest",
  "args": {
    "data": {
      "requestId": "46308.75",
      "frame": "0x1bb474a68240",
      "url": "https://api.github.com/_private/browser/stats",
      "requestMethod": "POST",
      "stackTrace": [
        {
          "functionName": "n",
          "scriptId": "142",
          "url": "https://assets-cdn.github.com/assets/github-37bdbe413b8d63eb404649438916711bf73507e197a30398097bc716eaec7784.js",
          "lineNumber": 2,
          "columnNumber": 7991
        }
      ]
    }
  },
  "tts": 2602505,
  "s": "t"
}
```

#### ResourceReceiveResponse

##### Arguments

* `data.requestId`: Id of the request, matching the other events.
* `data.frame`: Id of the loading frame.
* `data.statusCode`: HTTP status code received from the remote server.
* `data.mimeType`: Content type of the response entity.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923137730211,
  "ph": "I",
  "cat": "devtools.timeline",
  "name": "ResourceReceiveResponse",
  "args": {
    "data": {
      "requestId": "46308.75",
      "frame": "0x1bb474a68240",
      "statusCode": 200,
      "mimeType": "application/json"
    }
  },
  "tts": 2604816,
  "s": "t"
}
```

#### ResourceReceivedData

##### Arguments

* `data.requestId`: Guess..?
* `data.frame`: Guess..?
* `data.encodedDataLength`: Number of bytes received.

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923137730510,
  "ph": "I",
  "cat": "devtools.timeline",
  "name": "ResourceReceivedData",
  "args": {
    "data": {
      "requestId": "46308.75",
      "frame": "0x1bb474a68240",
      "encodedDataLength": 799
    }
  },
  "tts": 2605051,
  "s": "t"
}
```

#### ResourceFinish

##### Arguments

* `data.requestId`: Same.
* `data.didFail`: False unless the response could not be received.
* `data.networkTime`: Looks like a timestamp..?

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 923137730848,
  "ph": "I",
  "cat": "devtools.timeline",
  "name": "ResourceFinish",
  "args": {
    "data": {
      "requestId": "46308.75",
      "didFail": false,
      "networkTime": 923137.730634
    }
  },
  "tts": 2605234,
  "s": "t"
}
```

### Metadata Events

#### num_cpus

##### Example

```json
{
  "pid": 46273,
  "tid": 0,
  "ts": 0,
  "ph": "M",
  "cat": "__metadata",
  "name": "num_cpus",
  "args": {
    "number": 8
  }
}
```

#### process_labels

##### Example

```json
{
  "pid": 46308,
  "tid": 17187,
  "ts": 0,
  "ph": "M",
  "cat": "__metadata",
  "name": "process_labels",
  "args": {
    "labels": "request/request"
  }
}
```

#### process_name

##### Example

```json
{
  "pid": 46273,
  "tid": 30539,
  "ts": 0,
  "ph": "M",
  "cat": "__metadata",
  "name": "process_name",
  "args": {
    "name": "Browser"
  }
}
```

#### process_sort_index

##### Example

```json
{
  "pid": 46273,
  "tid": 30539,
  "ts": 0,
  "ph": "M",
  "cat": "__metadata",
  "name": "process_sort_index",
  "args": {
    "sort_index": -6
  }
}
```

#### thread_name

##### Example

```json
{
  "pid": 46325,
  "tid": 24095,
  "ts": 0,
  "ph": "M",
  "cat": "__metadata",
  "name": "thread_name",
  "args": {
    "name": "HTMLParserThread"
  }
}
```

#### thread_sort_index

##### Example

```json
{
  "pid": 46308,
  "tid": 1295,
  "ts": 0,
  "ph": "M",
  "cat": "__metadata",
  "name": "thread_sort_index",
  "args": {
    "sort_index": -1
  }
}
```

### Sample of Event Names (excluding `toplevel`)

```bash
  33 "ActivateLayerTree"
2242 "AnalyzeTask"
  86 "BeginFrame"
  59 "BeginMainThreadFrame"
   6 "CommitLoad"
 120 "CompositeLayers"
   4 "Decode Image"
   4 "Decode LazyPixelRef"
  12 "Draw LazyPixelRef"
  33 "DrawFrame"
  56 "EvaluateScript"
 128 "EventDispatch"
  30 "FireAnimationFrame"
 458 "FunctionCall"
   2 "HitTest"
   4 "ImageDecodeTask"
  66 "InvalidateLayout"
 122 "Layout"
  42 "MajorGC"
  11 "MarkDOMContent"
   6 "MarkLoad"
  34 "MinorGC"
  51 "NeedsBeginFrameChanged"
  68 "Paint"
  29 "PaintImage"
   2 "ParseAuthorStyleSheet"
  90 "ParseHTML"
1573 "RasterTask"
  31 "RequestAnimationFrame"
  57 "RequestMainThreadFrame"
  29 "ResourceFinish"
  28 "ResourceReceiveResponse"
 115 "ResourceReceivedData"
  29 "ResourceSendRequest"
  58 "ScheduleStyleRecalculation"
  21 "ScrollLayer"
   1 "SetLayerTreeId"
  38 "TimerFire"
  39 "TimerInstall"
  10 "TimerRemove"
   1 "TracingStartedInPage"
 280 "UpdateCounters"
 127 "UpdateLayer"
 108 "UpdateLayerTree"
 116 "UpdateLayoutTree"
   1 "WebSocketCreate"
   1 "WebSocketDestroy"
   1 "WebSocketReceiveHandshakeResponse"
   1 "WebSocketSendHandshakeRequest"
   1 "XHRLoad"
   3 "XHRReadyStateChange"
  18 "layerId"
   3 "num_cpus"
   1 "process_labels"
   3 "process_name"
   3 "process_sort_index"
  43 "thread_name"
   2 "thread_sort_index"
```
