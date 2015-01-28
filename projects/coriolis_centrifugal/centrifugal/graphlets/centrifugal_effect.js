var refreshCheckboxes = function () {
    document.getElementById('traces').checked = true;
    document.getElementById('centrfcor').checked = true;
    document.getElementById('quadrants').checked = true;
    document.getElementById('disks').checked = true;
    document.getElementById('autohalt').checked = true;
    document.getElementById('onhaltreset').checked = true;
}
refreshCheckboxes();  // refreshCheckboxes is also called by 'resetAll()'

var boundery = 125;  // boundary of the viewport in user coordinates
var pr = 100;  // The radius of the disk

var boardLeft = JXG.JSXGraph.initBoard('jxgboxleft', {boundingbox: [-boundery, boundery, boundery, -boundery], showNavigation: false, pan: {enabled: false}, axis: false, grid: false} );

var boardRight = JXG.JSXGraph.initBoard('jxgboxright', {boundingbox: [-boundery, boundery, boundery, -boundery], showNavigation: false, pan: {enabled: false}, axis: false, grid: false, showCopyright:false} );

boardLeft.addChild(boardRight);

var pi = Math.PI;

var distMin = 1;
var distInitial = 50;
var distMax = 100;

var speedMin = -2;
var speedInitial = 0;
var speedMax = 1;

var dist = boardLeft.create(
    'slider',[
        [-80, -boundery+10],[80, -boundery+10],[distMin,distInitial,distMax]
    ],
    {snapWidth:1}
); // dist from center of rotation 

var speed = boardRight.create(
    'slider',[
        [-80, -boundery+10],[80, -boundery+10],[speedMin, speedInitial, speedMax]
    ],
    {snapWidth:0.1}
);

// Left and right are two different perspectives on the same thing.
// On the left a rotating disk is shown
// On the right the same disk is shown, as seen from a co-rotating perspective
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
    {strokeWidth:0, strokeOpacity:0, fillColor:'#eeeeee', needsRegularUpdate:false, layer:1, highlight:false}
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



var angle = 0;

var cosAngle  = function() {return Math.cos(angle)};
var sinAngle  = function() {return Math.sin(angle)};
var cpr       = function() {return cosAngle()*pr};
var spr       = function() {return sinAngle()*pr};



var sectorLeft1 = boardLeft.create(
    'sector', [
        [0, 0],
        [function () {return cpr();}, function () {return spr();}],
        [function () {return -spr();}, function () {return cpr();}]
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc',needsRegularUpdate:true, highlight:false}
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
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc',needsRegularUpdate:false, highlight:false}
);

var sectorRight2 = boardRight.create(
    'sector', [
        [0, 0],
        [-pr, 0],
        [0, -pr]
    ],
    {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc',needsRegularUpdate:false, highlight:false}
);



// the variable 'released' is either the value 0 or 1, and is employed 
// both as a flag and as a multiplication factor
var released = 0;

var linearMotion = function() {return dist.Value()*(1+speed.Value())*angle*released};

var pointLeftX  = function() {
    if (released === 1) {return dist.Value()}
    else {return cosAngle()*dist.Value()}
};
var pointLeftY  = function() {
    if (released === 1) {return linearMotion()}
    else {return sinAngle()*dist.Value()}
};
var pointRightX = function() {return cosAngle()*pointLeftX() + sinAngle()*pointLeftY()};
var pointRightY = function() {return -sinAngle()*pointLeftX() + cosAngle()*pointLeftY()};


var pointLeft = boardLeft.create(
    'point', [
        function() {return pointLeftX()},
        function() {return pointLeftY()}
    ],
    {name:'', size:4, strokeWidth:0, strokeOpacity:0, fillColor:'#000000', highlight:false}
);

var pointRight = boardRight.create(
    'point', [
        function() {return pointRightX()},
        function() {return pointRightY()}
    ],
    {name:'', size:4, strokeWidth:0, strokeOpacity:0, fillColor:'#000000', highlight:false}
);


var traceCurveLeft  = boardLeft.create('curve', [[], []], {strokeColor: 'black', highlight:false});
var traceCurveRight = boardRight.create('curve', [[], []], {strokeColor: 'black', highlight:false});

var pushCurveArrays = function() {
    traceCurveLeft.dataX.push(pointLeftX());
    traceCurveLeft.dataY.push(pointLeftY());
    traceCurveRight.dataX.push(pointRightX());
    traceCurveRight.dataY.push(pointRightY());
};


/*
 About the lengths of the centrifugal vector and the coriolis vector:
 How do you know whether those lengths are in the right proportion to each other?
 In this animation the angular velocity is 1 radian per 1 unit of time. So the length of the centrifugal vector is proportional to the radial distance 'r' to the center. As drawn the length of the line is half of that: 0.5*r
 The magnitude of the Coriolis force is given by the expression 2*v*omega
 The factor _2_ in the expression for the coriolis force has been moved to the
 centrifugal force, so that the two of them are in the correct proportion.
 */
// Centrifugal force
var centrf = boardRight.create(
    'line',[
        [function() {return     pointRightX()}, function() {return     pointRightY()}],
        [function() {return 1.5*pointRightX()}, function() {return 1.5*pointRightY()}]
    ],
    {straightFirst:false, straightLast:false, strokeWidth:2, strokeColor:'#B22', lastArrow:true, highlight:false, visible:true}
);

// the x-component of the position relative to the rotating coordinate system:
// cosAngle()*dist.Value() + sinAngle()*(dist.Value()*(1+speed.Value())*angle)
// derivitive with respect to time of the x-component to obtain x-component of _velocity_
var velocityRightX = function() {return (-sinAngle()*dist.Value() + cosAngle()*(dist.Value()*(1+speed.Value())*angle) + sinAngle()*dist.Value()*(1+speed.Value()))*released};
// the y-component of the position relative to the rotating coordinate system:
// -sinAngle()*dist.Value() + cosAngle()*(dist.Value()*(1+speed.Value())*angle)
// derivitive with respect to time of the y-component to obtain y-component of _velocity_
var velocityRightY = function() {return (-cosAngle()*dist.Value() - sinAngle()*(dist.Value()*(1+speed.Value())*angle) + cosAngle()*dist.Value()*(1+speed.Value()))*released};

// Coriolis force
// Note: X-and-Y mixing: pointRightX + velocityRightY, pointRightY - velocityRightX, 
// so that the coriolis vector comes out perpendicular to the velocity vector
var coriolis = boardRight.create(
    'line',[
        [function() {return pointRightX()                   }, function() {return pointRightY()}],
        [function() {return pointRightX() + velocityRightY()}, function() {return pointRightY() - velocityRightX()}]
    ],
    {straightFirst:false, straightLast:false, strokeWidth:2, strokeColor:'#22B', lastArrow:true, highlight:false, visible:true}
);


// Note the workaround code for the coriolis vector
// See also the comment to the variable 'refreshVisibilities'.
// when released === 0 then setting the visibility is one way: 
// you can toggle to visible:false, but not to visible:true
var centrfCor = document.getElementById('centrfcor');
JXG.addEvent(centrfcor, 'change', function (e) {
    centrf.setAttribute({visible: centrfcor.checked});
    if (released === 1 ) {
        coriolis.setAttribute({visible: centrfcor.checked});
    }
    else if (centrfcor.checked === false) {coriolis.setAttribute({visible:false});}
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


var setElementAttributes = function() {
    dist.point1.setAttribute({needsRegularUpdate:isPaused});
    dist.point2.setAttribute({needsRegularUpdate:isPaused});
    dist.baseline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    dist.highline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
//  dist.label.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    dist.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    speed.point1.setAttribute({needsRegularUpdate:isPaused});
    speed.point2.setAttribute({needsRegularUpdate:isPaused});
    speed.baseline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    speed.highline.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
//  speed.label.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
    speed.setAttribute({visible:isPaused, needsRegularUpdate:isPaused});
};


// Note that setting the visibility of the coriolis vector has been commented out.
// Instead the visibility is toggled in the function 'playing
// When point1 and point2 of a line element coincide updates to the line element 
// are suspended. As a side effect some cache is not flushed, and in a variety 
// of use cases an outdated (hence incorrect) coriolis vector is inserted in the 
// DOM. 
// Another location with workaround code: JXG.addEvent for the coriolis vector

// Issue report by Michael  https://github.com/jsxgraph/jsxgraph/issues/26
var refreshVisibilities = function() {
    centrf.setAttribute({visible: centrfcor.checked});
    //coriolis.setAttribute({visible: centrfcor.checked});
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
}



var cycle = 2*pi;
var steps = 200;
var increment = cycle/steps;
var loopEnd = cycle - increment/2;

var interval;
var isPlaying = false;
var isPaused = !isPlaying;

var playing = function() {
    angle = angle + increment;
    if (released === 0 && angle > loopEnd) {
        angle = 0;
        released = 1;
        coriolis.setAttribute({visible: centrfcor.checked})
    };
    if (autohalt.checked === true && Math.abs(linearMotion()) > boundery) {
        pause();
        if (onhaltreset.checked === true) {setTimeout(resetView,2000)}
    }
    if (traces.checked === true) {pushCurveArrays()};
    boardLeft.update();  // boardRight is child of boardLeft
};

// The variable 'interval' must be declared outside the function play(). If not
// the function pause() would not have access to it.

var play = function() {
    if (isPlaying === false) {
        isPlaying = true;
        isPaused = !isPlaying;
        setElementAttributes();
        interval = setInterval(playing,50);
        document.getElementById('playpausebutton').innerHTML = 'pause';
    }
    else {
        pause();
    }
};

var pause = function() {
    clearInterval(interval);
    isPlaying = false;
    isPaused = !isPlaying;
    document.getElementById('playpausebutton').innerHTML = 'play';
};

// reset animation to the current inputs
var resetView = function() {
    if (isPlaying === true) {pause();}
    setElementAttributes();
    angle = 0;
    released = 0;
    coriolis.setAttribute({visible:false});
    traceCurveLeft.dataX.length = 0;
    traceCurveLeft.dataY.length = 0;
    traceCurveRight.dataX.length = 0;
    traceCurveRight.dataY.length = 0;
    boardLeft.update();
};


// Reset animation and reset inputs to defaults
var resetAll = function() {
    resetView();
    dist.position = (distInitial - distMin) / (distMax - distMin);
    speed.position = (speedInitial - speedMin) / (speedMax - speedMin);
    refreshCheckboxes();
    refreshVisibilities();
    boardLeft.update();
};  