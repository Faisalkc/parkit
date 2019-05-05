document.write('<link rel="stylesheet" href="https://github.githubassets.com/assets/gist-embed-a9a1cf2ca01efd362bfa52312712ae94.css">')
document.write('<div id=\"gist95726768\" class=\"gist\">\n    <div class=\"gist-file\">\n      <div class=\"gist-data\">\n        <div class=\"js-gist-file-update-container js-task-list-container file-box\">\n  <div id=\"file-counterbloc-dart\" class=\"file\">\n    \n\n  <div itemprop=\"text\" class=\"Box-body p-0 blob-wrapper data type-dart \">\n      \n<table class=\"highlight tab-size js-file-line-container\" data-tab-size=\"8\">\n      <tr>\n        <td id=\"file-counterbloc-dart-L1\" class=\"blob-num js-line-number\" data-line-number=\"1\"><\/td>\n        <td id=\"file-counterbloc-dart-LC1\" class=\"blob-code blob-code-inner js-file-line\"><span class=\"pl-k\">import<\/span> <span class=\"pl-s\">&#39;package:rxdart/rxdart.dart&#39;<\/span>;<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L2\" class=\"blob-num js-line-number\" data-line-number=\"2\"><\/td>\n        <td id=\"file-counterbloc-dart-LC2\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L3\" class=\"blob-num js-line-number\" data-line-number=\"3\"><\/td>\n        <td id=\"file-counterbloc-dart-LC3\" class=\"blob-code blob-code-inner js-file-line\"><span class=\"pl-k\">class<\/span> <span class=\"pl-c1\">CounterBloc<\/span> {<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L4\" class=\"blob-num js-line-number\" data-line-number=\"4\"><\/td>\n        <td id=\"file-counterbloc-dart-LC4\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L5\" class=\"blob-num js-line-number\" data-line-number=\"5\"><\/td>\n        <td id=\"file-counterbloc-dart-LC5\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-k\">int<\/span> initialCount <span class=\"pl-k\">=<\/span> <span class=\"pl-c1\">0<\/span>; <span class=\"pl-c\">//if the data is not passed by paramether it initializes with 0<\/span><\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L6\" class=\"blob-num js-line-number\" data-line-number=\"6\"><\/td>\n        <td id=\"file-counterbloc-dart-LC6\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-c1\">BehaviorSubject<\/span><span class=\"pl-k\">&lt;<\/span><span class=\"pl-k\">int<\/span><span class=\"pl-k\">&gt;<\/span> _subjectCounter;<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L7\" class=\"blob-num js-line-number\" data-line-number=\"7\"><\/td>\n        <td id=\"file-counterbloc-dart-LC7\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L8\" class=\"blob-num js-line-number\" data-line-number=\"8\"><\/td>\n        <td id=\"file-counterbloc-dart-LC8\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-c1\">CounterBloc<\/span>({<span class=\"pl-c1\">this<\/span>.initialCount}){<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L9\" class=\"blob-num js-line-number\" data-line-number=\"9\"><\/td>\n        <td id=\"file-counterbloc-dart-LC9\" class=\"blob-code blob-code-inner js-file-line\">   _subjectCounter <span class=\"pl-k\">=<\/span> <span class=\"pl-k\">new<\/span> <span class=\"pl-c1\">BehaviorSubject<\/span><span class=\"pl-k\">&lt;<\/span><span class=\"pl-k\">int<\/span><span class=\"pl-k\">&gt;<\/span>.<span class=\"pl-en\">seeded<\/span>(<span class=\"pl-c1\">this<\/span>.initialCount); <span class=\"pl-c\">//initializes the subject with element already<\/span><\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L10\" class=\"blob-num js-line-number\" data-line-number=\"10\"><\/td>\n        <td id=\"file-counterbloc-dart-LC10\" class=\"blob-code blob-code-inner js-file-line\">  }<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L11\" class=\"blob-num js-line-number\" data-line-number=\"11\"><\/td>\n        <td id=\"file-counterbloc-dart-LC11\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L12\" class=\"blob-num js-line-number\" data-line-number=\"12\"><\/td>\n        <td id=\"file-counterbloc-dart-LC12\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-c1\">Observable<\/span><span class=\"pl-k\">&lt;<\/span><span class=\"pl-k\">int<\/span><span class=\"pl-k\">&gt;<\/span> <span class=\"pl-k\">get<\/span> <span class=\"pl-en\">counterObservable<\/span> =&gt; _subjectCounter.stream; <\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L13\" class=\"blob-num js-line-number\" data-line-number=\"13\"><\/td>\n        <td id=\"file-counterbloc-dart-LC13\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L14\" class=\"blob-num js-line-number\" data-line-number=\"14\"><\/td>\n        <td id=\"file-counterbloc-dart-LC14\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-k\">void<\/span> <span class=\"pl-en\">increment<\/span>(){<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L15\" class=\"blob-num js-line-number\" data-line-number=\"15\"><\/td>\n        <td id=\"file-counterbloc-dart-LC15\" class=\"blob-code blob-code-inner js-file-line\">    initialCount<span class=\"pl-k\">++<\/span>;<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L16\" class=\"blob-num js-line-number\" data-line-number=\"16\"><\/td>\n        <td id=\"file-counterbloc-dart-LC16\" class=\"blob-code blob-code-inner js-file-line\">    _subjectCounter.sink.<span class=\"pl-en\">add<\/span>(initialCount);<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L17\" class=\"blob-num js-line-number\" data-line-number=\"17\"><\/td>\n        <td id=\"file-counterbloc-dart-LC17\" class=\"blob-code blob-code-inner js-file-line\">  }<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L18\" class=\"blob-num js-line-number\" data-line-number=\"18\"><\/td>\n        <td id=\"file-counterbloc-dart-LC18\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L19\" class=\"blob-num js-line-number\" data-line-number=\"19\"><\/td>\n        <td id=\"file-counterbloc-dart-LC19\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-k\">void<\/span> <span class=\"pl-en\">decrement<\/span>(){<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L20\" class=\"blob-num js-line-number\" data-line-number=\"20\"><\/td>\n        <td id=\"file-counterbloc-dart-LC20\" class=\"blob-code blob-code-inner js-file-line\">    initialCount<span class=\"pl-k\">--<\/span>;<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L21\" class=\"blob-num js-line-number\" data-line-number=\"21\"><\/td>\n        <td id=\"file-counterbloc-dart-LC21\" class=\"blob-code blob-code-inner js-file-line\">    _subjectCounter.sink.<span class=\"pl-en\">add<\/span>(initialCount);<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L22\" class=\"blob-num js-line-number\" data-line-number=\"22\"><\/td>\n        <td id=\"file-counterbloc-dart-LC22\" class=\"blob-code blob-code-inner js-file-line\">  }<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L23\" class=\"blob-num js-line-number\" data-line-number=\"23\"><\/td>\n        <td id=\"file-counterbloc-dart-LC23\" class=\"blob-code blob-code-inner js-file-line\">\n<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L24\" class=\"blob-num js-line-number\" data-line-number=\"24\"><\/td>\n        <td id=\"file-counterbloc-dart-LC24\" class=\"blob-code blob-code-inner js-file-line\">  <span class=\"pl-k\">void<\/span> <span class=\"pl-en\">dispose<\/span>(){<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L25\" class=\"blob-num js-line-number\" data-line-number=\"25\"><\/td>\n        <td id=\"file-counterbloc-dart-LC25\" class=\"blob-code blob-code-inner js-file-line\">    _subjectCounter.<span class=\"pl-en\">close<\/span>();<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L26\" class=\"blob-num js-line-number\" data-line-number=\"26\"><\/td>\n        <td id=\"file-counterbloc-dart-LC26\" class=\"blob-code blob-code-inner js-file-line\">  }<\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L27\" class=\"blob-num js-line-number\" data-line-number=\"27\"><\/td>\n        <td id=\"file-counterbloc-dart-LC27\" class=\"blob-code blob-code-inner js-file-line\">  <\/td>\n      <\/tr>\n      <tr>\n        <td id=\"file-counterbloc-dart-L28\" class=\"blob-num js-line-number\" data-line-number=\"28\"><\/td>\n        <td id=\"file-counterbloc-dart-LC28\" class=\"blob-code blob-code-inner js-file-line\">}<\/td>\n      <\/tr>\n<\/table>\n\n\n  <\/div>\n\n  <\/div>\n<\/div>\n\n      <\/div>\n      <div class=\"gist-meta\">\n        <a href=\"https://gist.github.com/wiltonribeiro/a098fb720f14e4e1005b6c1b660d998b/raw/be975767b16bb453d65bc46071a36e997169283f/CounterBloc.dart\" style=\"float:right\">view raw<\/a>\n        <a href=\"https://gist.github.com/wiltonribeiro/a098fb720f14e4e1005b6c1b660d998b#file-counterbloc-dart\">CounterBloc.dart<\/a>\n        hosted with &#10084; by <a href=\"https://github.com\">GitHub<\/a>\n      <\/div>\n    <\/div>\n<\/div>\n')