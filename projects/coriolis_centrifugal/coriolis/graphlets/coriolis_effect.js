var refreshCheckboxes = function () {
    document.getElementById('centripetal').checked = true;
    document.getElementById('traces').checked = true;
    document.getElementById('quadrants').checked = true;
    document.getElementById('centrfcor').checked = false;
    document.getElementById('circles').checked = false;
    document.getElementById('disks').checked = true;
}
refreshCheckboxes();
// This refresh is necessaray because Firefox preserves old checkbox 
// settings, even after a page reload with F5.
// refreshCheckboxes is also called by 'resetAll()'

var boardLeft = JXG.JSXGraph.initBoard('jxgboxleft', {boundingbox: [-100, 95, 100, -85], showNavigation: false, pan: {enabled: false}, axis: false, grid: false} );

var boardRight = JXG.JSXGraph.initBoard('jxgboxright', {boundingbox: [-100, 95, 100, -85], showNavigation: false, pan: {enabled: false}, axis: false, grid: false, showCopyright:false} );

var boardSliders = JXG.JSXGraph.initBoard('jxgboxsliders', {boundingbox: [-200, 2.5, 200, -2.5], showNavigation: false, pan: {enabled: false}, axis: false, grid: false, showCopyright:false} );

boardSliders.addChild(boardRight);
boardSliders.addChild(boardLeft);

var pi = Math.PI;

var mainMin = 20;
var mainInitial = 45;
var mainMax = 60;
var epiMin = 0.0;
var epiInitial = 15;
var epiMax = 20;


var main = boardSliders.create(
    'slider',[
        [-170, 0],[-30, 0],[mainMin,mainInitial,mainMax]
    ],
    {snapWidth:1}
); // main circle radius 

var epi = boardSliders.create(
    'slider',[
        [30, 0],[170, 0],[epiMin, epiInitial, epiMax]
    ],
    {snapWidth:1}
);  // epicircle radius

var maj = function () {return main.Value() + epi.Value();};  // major axis of ellipse
var min = function () {return main.Value() - epi.Value();};  // minor axis of ellipse


// Left and right are two different perspectives on the same thing.
// On the left a rotating disk is shown
// On the right the same disk is shown, as seen from a co-rotating perspective

var pr = 80;  // The radius of the disk
var angle = 0;

// Assuming that computing sine and cosine is more expensive than multiplying etc., 
// Math.sin() and Math.cos() are called only once, all other sines and cosines are computed 
// from those
var cosAngle  = function () {return Math.cos(angle);};
var sinAngle  = function () {return Math.sin(angle);};
var cos2Angle = function () {return 2*cosAngle()*cosAngle() - 1;};
var sin2Angle = function () {return 2*cosAngle()*sinAngle();};
var cpr       = function () {return cosAngle()*pr;};
var spr       = function () {return sinAngle()*pr;};

var platformLeftShadow = boardLeft.create(
    'circle', [
        [2, -2],
        pr
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'black', needsRegularUpdate:false, layer:0, highlight:false}
);

var platformLeft = boardLeft.create(
    'circle', [
        [0, 0],
        pr
    ],
    {strokeWidth:0, strokeOpacity:0,  fillColor:'#eeeeee', needsRegularUpdate:false, layer:1, highlight:false}
);

var platformRightShadow = boardRight.create(
    'circle', [
        [2, -2],
        pr
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'black', needsRegularUpdate:false, layer:0, highlight:false}
);

var platformRight = boardRight.create(
    'circle', [
        [0, 0],
        pr
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#eeeeee', needsRegularUpdate:false, layer:1, highlight:false}
);



var sectorLeft1 = boardLeft.create(
    'sector', [
        [0, 0],
        [function () {return cpr();}, function () {return spr();}],
        [function () {return -spr();}, function () {return cpr();}]
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc', needsRegularUpdate:true, highlight:false}
);

var sectorLeft2 = boardLeft.create(
    'sector', [
        [0, 0],
        [function () {return -cpr();}, function () {return -spr();}],
        [function () {return spr();}, function () {return -cpr();}]
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc',needsRegularUpdate:true, highlight:false}
);


var sectorRight1 = boardRight.create(
    'sector', [
        [0, 0],
        [pr, 0],
        [0, pr]
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc', needsRegularUpdate:false, highlight:false}
);

var sectorRight2 = boardRight.create(
    'sector', [
        [0, 0],
        [-pr, 0],
        [0, -pr]
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc', needsRegularUpdate:false, highlight:false}
);



var circleMainLeft = boardLeft.create(
    'circle', [
        [0, 0],
        function () {return main.Value();}
    ],
    {visible:false, strokeColor:'#888888', highlight:false}
);

var circleEpiLeft = boardLeft.create(
    'circle', [
        [function () {return cosAngle()*main.Value();}, function () {return sinAngle()*main.Value();}],
        function () {return epi.Value();}
    ],
    {visible:false, strokeColor:'#888888', highlight:false}
);

var circleMainRight = boardRight.create(
    'circle', [
        [0, 0],
        function () {return main.Value();}
    ],
    {visible:false, strokeColor:'#888888', highlight:false}
);

var circleEpiRight = boardRight.create(
    'circle', [
        [function () {return main.Value();}, 0],
        function () {return epi.Value();}
    ],
    {visible:false, strokeColor:'#888888', highlight:false}
);


// These values are parents to eight elements: The two points, 
// the two traces of the points, the two centripetal force vectors, 
// the centrifugal force vector and the coriolis force vector
var pointLeftX      = function () {return   cosAngle()*maj();};
var pointLeftY      = function () {return   sinAngle()*min();};
var pointRightX     = function () {return  cos2Angle()*epi.Value() + main.Value();};
var pointRightY     = function () {return -sin2Angle()*epi.Value();};

var pointLeft = boardLeft.create(
    'point', [
        function () {return pointLeftX();},
        function () {return pointLeftY();}
    ],
    {withLabel:false, size:4, strokeWidth:0, strokeOpacity:0, fillColor:'#000000', highlight:false}
);

var pointRight = boardRight.create(
    'point', [
        function () {return pointRightX();},
        function () {return pointRightY();}
    ],
    {withLabel:false, size:4, strokeWidth:0, strokeOpacity:0, fillColor:'#000000', highlight:false}
);

var traceCurveLeft  = boardLeft.create('curve', [[], []], {strokeColor: 'black', highlight:false});
var traceCurveRight = boardRight.create('curve', [[], []], {strokeColor: 'black', highlight:false});

var pushCurveArrays = function () {
    traceCurveLeft.dataX.push(pointLeftX());
    traceCurveLeft.dataY.push(pointLeftY());
    traceCurveRight.dataX.push(pointRightX());
    traceCurveRight.dataY.push(pointRightY());
};


// Centripetal force, left side.
var centrpLeft = boardLeft.create(
    'line',[
        [function () {return     pointLeftX();}, function () {return     pointLeftY();}],
        [function () {return 0.5*pointLeftX();}, function () {return 0.5*pointLeftY();}]
    ],
    {strokeWidth:2, strokeColor:'green', straightFirst:false, straightLast:false, lastArrow:true, needsRegularUpdate:true, highlight:false}
);

var centrpRight = boardRight.create(
    'line',[
        [function () {return     pointRightX();}, function () {return     pointRightY();}],
        [function () {return 0.5*pointRightX();}, function () {return 0.5*pointRightY();}]
    ],
    {strokeWidth:2, strokeColor:'green', straightFirst:false, straightLast:false, lastArrow:true, needsRegularUpdate:true, highlight:false}
);

// Centrifugal force
var centrf = boardRight.create(
    'line',[
        [function () {return     pointRightX();}, function () {return     pointRightY();}],
        [function () {return 1.5*pointRightX();}, function () {return 1.5*pointRightY();}]
    ],
    {straightFirst:false, straightLast:false, strokeWidth:2, strokeColor:'#C22', lastArrow:true, highlight:false, visible:false}
);

// Coriolis force
var coriolis = boardRight.create(
    'line',[
        [function () {return  pointRightX();},                  function () {return  pointRightY();}],
        [function () {return -pointRightX() + 2*main.Value();}, function () {return -pointRightY();}]
    ],
    {straightFirst:false, straightLast:false, strokeWidth:2, strokeColor:'#22B', lastArrow:true, highlight:false, visible:false}
);

var centripetal = document.getElementById('centripetal');
JXG.addEvent(centripetal, 'change', function (e) {
    centrpLeft.setAttribute({visible: centripetal.checked});
    centrpRight.setAttribute({visible: centripetal.checked});
}, this);

var centrfCor = document.getElementById('centrfcor');
JXG.addEvent(centrfcor, 'change', function (e) {
    centrf.setAttribute({visible: centrfcor.checked});
    coriolis.setAttribute({visible: centrfcor.checked});
}, this);

var traces = document.getElementById('traces');
JXG.addEvent(traces, 'change', function (e) {
    traceCurveLeft.setAttribute({visible: traces.checked});
    traceCurveRight.setAttribute({visible: traces.checked});
    if (traces.checked === false) {
        traceCurveLeft.dataX.length = 0;
        traceCurveLeft.dataY.length = 0;
        traceCurveRight.dataX.length = 0;
        traceCurveRight.dataY.length = 0;
    };
}, this);

var circles = document.getElementById('circles');
JXG.addEvent(circles, 'change', function (e) {
    circleMainLeft.setAttribute({visible: circles.checked});
    circleMainRight.setAttribute({visible: circles.checked});
    circleEpiLeft.setAttribute({visible: circles.checked});
    circleEpiRight.setAttribute({visible: circles.checked});
}, this);

var quadrants = document.getElementById('quadrants');
JXG.addEvent(quadrants, 'change', function (e) {
    sectorLeft1.setAttribute({visible: quadrants.checked});
    sectorLeft2.setAttribute({visible: quadrants.checked});
    sectorRight1.setAttribute({visible: quadrants.checked});
    sectorRight2.setAttribute({visible: quadrants.checked});
}, this);

var disks = document.getElementById('disks');
JXG.addEvent(disks, 'change', function (e) {
    platformLeftShadow.setAttribute({visible: disks.checked});
    platformLeft.setAttribute({visible: disks.checked});
    platformRightShadow.setAttribute({visible: disks.checked});
    platformRight.setAttribute({visible: disks.checked});
    document.getElementById('quadrants').checked = disks.checked;
    sectorLeft1.setAttribute({visible: quadrants.checked});
    sectorLeft2.setAttribute({visible: quadrants.checked});
    sectorRight1.setAttribute({visible: quadrants.checked});
    sectorRight2.setAttribute({visible: quadrants.checked});
}, this);


var setSliderAttributes = function () {
    epi.point1.setAttribute({needsRegularUpdate:isPaused});
    epi.point2.setAttribute({needsRegularUpdate:isPaused});
    epi.baseline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    epi.highline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    epi.label.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    epi.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    main.point1.setAttribute({needsRegularUpdate:isPaused});
    main.point2.setAttribute({needsRegularUpdate:isPaused});
    main.baseline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    main.highline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    main.label.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    main.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
};

var setCircleAttributes = function () {
    circleMainLeft.setAttribute ({needsRegularUpdate:isPaused});
    circleMainRight.setAttribute ({needsRegularUpdate:isPaused});
    circleEpiRight.setAttribute ({needsRegularUpdate:isPaused});
};


var refreshVisibilities = function () {
    circleMainLeft.setAttribute({visible: circles.checked});
    circleMainRight.setAttribute({visible: circles.checked});
    circleEpiLeft.setAttribute({visible: circles.checked});
    circleEpiRight.setAttribute({visible: circles.checked});
    centrpLeft.setAttribute({visible: centripetal.checked});
    centrpRight.setAttribute({visible: centripetal.checked});
    centrf.setAttribute({visible: centrfcor.checked});
    coriolis.setAttribute({visible: centrfcor.checked});
    sectorLeft1.setAttribute({visible: quadrants.checked});
    sectorLeft2.setAttribute({visible: quadrants.checked});
    sectorRight1.setAttribute({visible: quadrants.checked});
    sectorRight2.setAttribute({visible: quadrants.checked});
    traceCurveLeft.setAttribute({visible: traces.checked});
    traceCurveRight.setAttribute({visible: traces.checked});
    platformLeftShadow.setAttribute({visible: disks.checked});
    platformLeft.setAttribute({visible: disks.checked});
    platformRightShadow.setAttribute({visible: disks.checked});
    platformRight.setAttribute({visible: disks.checked});
};


var cycle = 2*pi;

var isPlaying = false;
var isPaused = !isPlaying;
var interval;

var starttime;
var timeElapsed;
var anglePause = 0;


var lastTimeCount = 0;
var frameCounter = 0;
var timeCounter = 0;

var framerateEstimate = function () {
    frameCounter = frameCounter + 1;
    timeCounter = timeElapsed - lastTimeCount;
    if (timeCounter > 1) {
        document.getElementById('fps').innerHTML = frameCounter;
        lastTimeCount = timeElapsed;
        frameCounter = 0;
    }
};


var playing = function () {
    timeElapsed = (Date.now() - starttime)/1000;
    angle = (anglePause + timeElapsed) % cycle;
    if (traces.checked === true  &&  traceCurveLeft.dataX.length <= 130) {pushCurveArrays();}
    // framerateEstimate();   //  Writes to: document.getElementById('fps').innerHTML
    boardSliders.update();
};

var play = function () {
    if (isPlaying === false) {
        starttime = Date.now();
        isPlaying = true;
        isPaused = !isPlaying;
        setSliderAttributes();
        interval = setInterval(playing,50);
        document.getElementById('playpausebutton').innerHTML = 'pause';
    }
    else {
        pause();
    }
};

var pause = function () {
    anglePause = angle;
    clearInterval(interval);
    isPlaying = false;
    isPaused = !isPlaying;
    document.getElementById('playpausebutton').innerHTML = 'play';
};


var resetDisplay = function () {
    if (isPlaying === true) {pause();}
    setSliderAttributes();
    timeElapsed = 0;
    lastTimeCount = 0;
    angle = 0;
    anglePause = 0;
    traceCurveLeft.dataX.length = 0;
    traceCurveLeft.dataY.length = 0;
    traceCurveRight.dataX.length = 0;
    traceCurveRight.dataY.length = 0;
};

var resetView = function () {
    resetDisplay();
    boardSliders.update();
};

var resetAll = function () {
    resetDisplay();
    main.position = (mainInitial - mainMin) / (mainMax - mainMin);
    epi.position = (epiInitial - epiMin) / (epiMax - epiMin);
    refreshCheckboxes();
    refreshVisibilities();
    boardSliders.update();
};  