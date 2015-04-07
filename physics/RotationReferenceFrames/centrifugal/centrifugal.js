$(document).ready(function() {
    var coriolisAlg = new Centrifugal({
        min: 0,
        max: 100,
        init: 50
    }, {
        min: -5,
        max: 5,
        init: 0
    }, 50);
    coriolisAlg.init();
     $("#playPauseButton").click(function() {
        coriolisAlg.play();
     });
     $("#resetView").click(function() {
        coriolisAlg.resetView();
     });
     $("#resetAll").click(function() {
        coriolisAlg.resetAll();
     });
    $("#speed").change(function() {
        coriolisAlg.setSteps($(this).val());
    })
});

function Centrifugal(dist, speed, steps) {
    /**
     * Left and right are two different perspectives on the same thing.
     * On the left a rotating disk is shown
     * On the right the same disk is shown, as seen from a co-rotating perspective
     */

    var that = this;

    var distMin = dist.min;
    var distMax = dist.max;
    var distInitial = dist.init;
    var speedMin = speed.min;
    var speedMax = speed.max;
    var speedInitial = speed.init;

    var boundary = 125;  // boundary of the viewport in user coordinates
    var diskRadius = 100;  // The radius of the disk

    this.interval = null;
    this.isPaused = true;

    /**
     * the variable 'released' is either the value 0 or 1, and is employed
     * both as a flag and as a multiplication factor
     */
    this.released = 0;

    this.$autoHalt = $("#autoHalt");

    this.angle = 0;
    this.boardLeft = null;
    this.boardRight = null;

    /** dist from center of rotation **/
    this.dist = null;
    this.speed = null;

    this.traceCurveLeft = null;
    this.traceCurveRight = null;

    /**
     * Coriolis force
     * X-and-Y mixing: pointRightX + velocityRightY, pointRightY - velocityRightX,
     * so that the coriolis vector comes out perpendicular to the velocity vector
    */
    this.coriolis = null;
    /** Centrifugal force **/
    this.centrifugal = null;

    this.init = function() {
        this.setSteps(steps);
        refreshCheckboxes();

        this.boardLeft = createBoard("jxgboxleft", boundary);
        this.boardRight = createBoard("jxgboxright", boundary);

        that.boardLeft.addChild(that.boardRight);

        this.angle = 0;
        this.dist = createSlider(that.boardLeft, boundary, distMin, distInitial, distMax);
        this.speed = createSlider(that.boardRight, boundary, speedMin, speedInitial, speedMax);
        createShadow(that.boardLeft, diskRadius);
        createShadow(that.boardRight, diskRadius);
        createPlatform(that.boardLeft, diskRadius);
        createPlatform(that.boardRight, diskRadius);
        this.createLeftSector(that.boardLeft, 1, diskRadius);
        this.createLeftSector(that.boardLeft, -1, diskRadius);
        createRightSector(that.boardRight, 1, diskRadius);
        createRightSector(that.boardRight, -1, diskRadius);

        createPoint(
            that.boardLeft,
            function() {return pointLeftX(that.dist, that.speed, that.angle, that.released);},
            function() {return pointLeftY(that.dist, that.speed, that.angle, that.released);}
        );
        createPoint(
            that.boardRight,
            function() {return pointRightX(that.dist, that.speed, that.angle, that.released);},
            function() {return pointRightY(that.dist, that.speed, that.angle, that.released);}
        );

        this.traceCurveLeft  = that.boardLeft.create('curve', [[], []], {strokeColor: 'black', highlight:false});
        this.traceCurveRight = that.boardRight.create('curve', [[], []], {strokeColor: 'black', highlight:false});

        this.centrifugal = createForce(
            that.boardRight,
            function() {return pointRightX(that.dist, that.speed, that.angle, that.released);},
            function() {return 1.5 * pointRightX(that.dist, that.speed, that.angle, that.released);},
            function() {return pointRightY(that.dist, that.speed, that.angle, that.released);},
            function() {return 1.5 * pointRightY(that.dist, that.speed, that.angle, that.released);},
            "#C22"
        );

        this.coriolis = createForce(
            that.boardRight,
            function(){return pointRightX(that.dist, that.speed, that.angle, that.released);},
            function(){return pointRightX(that.dist, that.speed, that.angle, that.released) + velocityRightY(that.dist, that.speed, that.angle, that.released);},
            function(){return pointRightY(that.dist, that.speed, that.angle, that.released);},
            function(){return pointRightY(that.dist, that.speed, that.angle, that.released) - velocityRightX(that.dist, that.speed, that.angle, that.released);},
            "#22B"
        );

        this.bindJXGEvents();
    };

    this.setSteps = function(steps) {
        this.steps = steps;
        this.increment = (2 * Math.PI) / this.steps;
        this.loopEnd = 2 * Math.PI - this.increment / 2;
    };

    this.playing = function() {
        that.angle = that.angle + that.increment;
        if (that.released === 0 && that.angle > that.loopEnd) {
            that.angle = 0;
            that.released = 1;
            that.setPowerStates();
        }
        if (that.$autoHalt.is(":checked") &&
                    Math.abs(linearMotion(that.dist, that.speed, that.angle, that.released)) > boundary) {
            that.pause();
        }
        if ($("#traces").is(":checked")) {
            that.pushCurveArrays();
        }
        that.boardLeft.update(); // that.boardRight is child of that.boardLeft
    };

    this.pause = function() {
        clearInterval(that.interval);
        that.isPaused = true;
        $("#playPauseButton").html("Play");
    };
    
    this.pushCurveArrays = function() {
        this.traceCurveLeft.dataX.push(pointLeftX(that.dist, that.speed, that.angle, that.released));
        this.traceCurveLeft.dataY.push(pointLeftY(that.dist, that.speed, that.angle, that.released));
        this.traceCurveRight.dataX.push(pointRightX(that.dist, that.speed, that.angle, that.released));
        this.traceCurveRight.dataY.push(pointRightY(that.dist, that.speed, that.angle, that.released));
    };

    this.bindJXGEvents = function() {
        var centrifugalCoriolis = document.getElementById("centrifugalCoriolis");
        JXG.addEvent(centrifugalCoriolis, 'change', function () {
            that.setPowerStates();
        }, this);

        var traces = document.getElementById("traces");
        JXG.addEvent(traces, 'change', function () {
            var checked = $("#traces").is(":checked");
            that.traceCurveLeft.setAttribute({visible: checked});
            that.traceCurveRight.setAttribute({visible: checked});
            if (!checked) {
                that.traceCurveLeft.dataX.length = 0;
                that.traceCurveLeft.dataY.length = 0;
                that.traceCurveRight.dataX.length = 0;
                that.traceCurveRight.dataY.length = 0;
            }
        }, this);
    };

    this.play = function() {
        if (this.isPaused) {
            this.isPaused = false;
            this.setElementAttributes(this.dist, this.speed, that.isPaused);
            this.interval = setInterval(that.playing, 50);
            $("#playPauseButton").html("Pause");
        } else {
            this.pause();
        }
    };

    /**
     * reset animation to the current inputs
     */
    this.resetView = function() {
        if (!this.isPaused) {
            this.pause();
        }
        this.setElementAttributes(this.dist, this.speed, this.isPaused);
        this.angle = 0;
        this.released = 0;
        this.traceCurveLeft.dataX.length = 0;
        this.traceCurveLeft.dataY.length = 0;
        this.traceCurveRight.dataX.length = 0;
        this.traceCurveRight.dataY.length = 0;
        this.boardLeft.update();
    };

    /**
     * Reset animation and reset inputs to defaults
     */
    this.resetAll = function() {
        this.dist.position = (distInitial - distMin) / (distMax - distMin);
        this.speed.position = (speedInitial - speedMin) / (speedMax - speedMin);
        this.resetView();
        refreshCheckboxes();
    };

    this.createLeftSector = function(board, flag, borderRadius) {
        return board.create(
            'sector', [
                [0, 0],
                [function () {return flag * cpr(that.angle, borderRadius);}, function () {return flag * spr(that.angle, borderRadius);}],
                [function () {return -flag * spr(that.angle, borderRadius);}, function () {return flag * cpr(that.angle, borderRadius);}]
            ],
            {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc',needsRegularUpdate:true, highlight:false}
        );
    };

    this.setElementAttributes = function() {
        this.dist.point1.setAttribute({needsRegularUpdate:that.isPaused});
        this.dist.point2.setAttribute({needsRegularUpdate:that.isPaused});
        this.dist.baseline.setAttribute({visible:that.isPaused, needsRegularUpdate:that.isPaused});
        this.dist.highline.setAttribute({visible:that.isPaused, needsRegularUpdate:that.isPaused});
        this.dist.setAttribute({visible:that.isPaused, needsRegularUpdate:that.isPaused});
        this.speed.point1.setAttribute({needsRegularUpdate:that.isPaused});
        this.speed.point2.setAttribute({needsRegularUpdate:that.isPaused});
        this.speed.baseline.setAttribute({visible:that.isPaused, needsRegularUpdate:that.isPaused});
        this.speed.highline.setAttribute({visible:that.isPaused, needsRegularUpdate:that.isPaused});
        this.speed.setAttribute({visible:that.isPaused, needsRegularUpdate:that.isPaused});
    };

    this.setPowerStates = function() {
        var visible = $("#centrifugalCoriolis").is(":checked");
        this.coriolis.setAttribute({visible: visible});
        this.centrifugal.setAttribute({visible: visible});
    };

    /** ============================================== DIFFERENT FUNCTIONS ========================================= **/
    function refreshCheckboxes() {
        // refreshCheckboxes is also called by 'resetAll()'
        $(".controlCheckboxes").find("input").each(function() {
            $(this).prop("checked", true);
        });
    }

    function createBoard(id, boundary) {
        /** @namespace JXG.JSXGraph */
        return JXG.JSXGraph.initBoard(id, {boundingbox: [-boundary, boundary, boundary, -boundary], showNavigation: false, pan: {enabled: false}, axis: false, grid: false, showCopyright:false});
    }

    function createSlider(board, boundary, min, init, max) {
        return board.create(
            'slider',[
                [-80, -boundary+10], [80, -boundary+10],[min, init, max]
            ], {snapWidth:0.1}
        );
    }

    function createShadow(board, diskRadius) {
        return board.create(
            'circle', [[2, -2], diskRadius], {strokeWidth:0, strokeOpacity:0, fillColor:'black', needsRegularUpdate:false, layer:0, highlight:false}
        );
    }

    function createPlatform(board, diskRadius) {
        return board.create(
            'circle', [[0, 0], diskRadius], {strokeWidth:0, strokeOpacity:0, fillColor:'#eeeeee', needsRegularUpdate:false, layer:1, highlight:false}
        );
    }

    function cosAngle(angle) {
        return Math.cos(angle);
    }

    function sinAngle(angle) {
        return Math.sin(angle);
    }

    function cpr(angle, diskRadius) {
        return cosAngle(angle)*diskRadius;
    }

    function spr(angle, diskRadius) {
        return sinAngle(angle)*diskRadius;
    }

    function createRightSector(board, flag, diskRadius) {
        return board.create(
            'sector', [
                [0, 0],
                [flag * diskRadius, 0],
                [0, flag * diskRadius]
            ],
            {strokeWidth:0, strokeOpacity:0, fillColor:'#ccc',needsRegularUpdate:false, highlight:false}
        );
    }

    function createPoint(board, xf, yf) {
        board.create(
            'point', [xf, yf],
            {name:'', size:4, strokeWidth:0, strokeOpacity:0, fillColor:'#000000', highlight:false}
        )
    }

    function linearMotion(dist, speed, angle, released) {
        return dist.Value() * (1 + speed.Value()) * angle * released;
    }

    function pointLeftX(dist, speed, angle, released) {
        if (released === 1) {
            return dist.Value();
        } else {
            return cosAngle(angle) * dist.Value();
        }
    }

    function pointLeftY(dist, speed, angle, released) {
        if (released === 1) {
            return linearMotion(dist, speed, angle, released);
        } else {
            return sinAngle(angle) * dist.Value();
        }
    }

    function pointRightX(dist, speed, angle, released) {
        return cosAngle(angle) * pointLeftX(dist, speed, angle, released) + sinAngle(angle) * pointLeftY(dist, speed, angle, released);
    }

    function pointRightY(dist, speed, angle, released) {
        return -sinAngle(angle) * pointLeftX(dist, speed, angle, released) + cosAngle(angle) * pointLeftY(dist, speed, angle, released);
    }

    /**
     * the x-component of the position relative to the rotating coordinate system:
     * cosAngle() * dist.Value() + sinAngle() * (dist.Value() * (1 + speed.Value()) * angle)
     * derivitive with respect to time of the x-component to obtain x-component of _velocity_
     */
    function velocityRightX(dist, speed, angle, released) {
        return (-sinAngle(angle) * dist.Value() +
            cosAngle(angle) * (dist.Value() * (1 + speed.Value()) * angle) +
            sinAngle(angle) * dist.Value() * (1 + speed.Value())) * released;
    }

    /**
     * the y-component of the position relative to the rotating coordinate system:
     * -sinAngle() * dist.Value() + cosAngle()*(dist.Value()*(1 + speed.Value()) * angle)
     * derivitive with respect to time of the y-component to obtain y-component of _velocity_
     */
    function velocityRightY(dist, speed, angle, released) {
        return (-cosAngle(angle) * dist.Value() -
            sinAngle(angle) * (dist.Value() * (1 + speed.Value()) * angle) +
            cosAngle(angle) * dist.Value() * (1 + speed.Value())) * released;
    }

    function createForce(board, xf1, xf2, yf1, yf2, color) {
        return board.create(
            'line',[[xf1, yf1], [xf2, yf2]],
            {straightFirst:false, straightLast:false, strokeWidth:2, strokeColor:color, lastArrow:true, highlight:false, visible:true}
        );
    }
    /** ============================================== DIFFERENT FUNCTIONS ========================================= **/
}