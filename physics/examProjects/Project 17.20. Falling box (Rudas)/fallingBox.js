var canvas,
    ctx,
    height = 800,
    width = 800,
    stiffness = 0.5,
    b = -1,
    angularB = -1,
    dt = 0.02;
Array.prototype.max = function () {
    return Math.max.apply(null, this);
};

Array.prototype.min = function () {
    return Math.min.apply(null, this);
};
var V = function (x, y) {
    this.x = x;
    this.y = y;
};

V.prototype.length = function () {
    return Math.sqrt(this.x * this.x + this.y * this.y);
};

V.prototype.add = function (v) {
    return new V(v.x + this.x, v.y + this.y);
};

V.prototype.subtract = function (v) {
    return new V(this.x - v.x, this.y - v.y);
};

V.prototype.scale = function (s) {
    return new V(this.x * s, this.y * s);
};

V.prototype.dot = function (v) {
    return (this.x * v.x + this.y * v.y);
};

V.prototype.cross = function (v) {
    return (this.x * v.y - this.y * v.x);
};

V.prototype.toString = function () {
    return '[' + this.x + ',' + this.y + ']';
};

V.prototype.rotate = function (angle, vector) {
    var x = this.x - vector.x;
    var y = this.y - vector.y;

    var x_prime = vector.x + ((x * Math.cos(angle)) - (y * Math.sin(angle)));
    var y_prime = vector.y + ((x * Math.sin(angle)) + (y * Math.cos(angle)));

    return new V(x_prime, y_prime);
};
var Rect = function (x, y, w, h, m) {
    if (typeof(m) === 'undefined') {
        this.m = 1;
    }

    this.width = w;
    this.height = h;

    this.active = true;

    this.topLeft = new V(x, y);
    this.topRight = new V(x + w, y);
    this.bottomRight = new V(x + w, y + h);
    this.bottomLeft = new V(x, y + h);

    this.v = new V(0, 0);
    this.a = new V(0, 0);
    this.theta = 0;
    this.omega = 0;
    this.alpha = 0;
    this.J = this.m * (this.height * this.height + this.width * this.width) / 12000;
};

Rect.prototype.center = function () {
    var diagonal = this.bottomRight.subtract(this.topLeft);
    var midpoint = this.topLeft.add(diagonal.scale(0.5));
    return midpoint;
};

Rect.prototype.rotate = function (angle) {
    this.theta += angle;
    var center = this.center();

    this.topLeft = this.topLeft.rotate(angle, center);
    this.topRight = this.topRight.rotate(angle, center);
    this.bottomRight = this.bottomRight.rotate(angle, center);
    this.bottomLeft = this.bottomLeft.rotate(angle, center);

    return this;
};

Rect.prototype.move = function (v) {
    this.topLeft = this.topLeft.add(v);
    this.topRight = this.topRight.add(v);
    this.bottomRight = this.bottomRight.add(v);
    this.bottomLeft = this.bottomLeft.add(v);

    return this;
};

Rect.prototype.draw = function (ctx) {
    ctx.strokeStyle = 'black';
    ctx.save();
    ctx.translate(this.topLeft.x, this.topLeft.y);
    ctx.rotate(this.theta);
    ctx.strokeRect(0, 0, this.width, this.height);
    ctx.restore();
};
Rect.prototype.vertex = function (id) {
    if (id == 0) {
        return this.topLeft;
    }
    else if (id == 1) {
        return this.topRight;
    }
    else if (id == 2) {
        return this.bottomRight;
    }
    else if (id == 3) {
        return this.bottomLeft;
    }
};
function intersect_safe(a, b) {
    var result = [];

    var as = a.map(function (x) {
        return x.toString();
    });
    var bs = b.map(function (x) {
        return x.toString();
    });

    for (var i in as) {
        if (bs.indexOf(as[i]) !== -1) {
            result.push(a[i]);
        }
    }

    return result;
}

satTest = function (a, b) {
    var testVectors = [
        a.topRight.subtract(a.topLeft),
        a.bottomRight.subtract(a.topRight),
        b.topRight.subtract(b.topLeft),
        b.bottomRight.subtract(b.topRight)
    ];
    var aInvolvedVertices = [];
    var bInvolvedVertices = [];

    /*
     * Look at each test vector (shadows)
     */
    for (var i = 0; i < 4; i++) {
        aInvolvedVertices[i] = []; // Our container for involved vertces
        bInvolvedVertices[i] = []; // Our container for involved vertces
        var myProjections = [];
        var foreignProjections = [];

        for (var j = 0; j < 4; j++) {
            myProjections.push(testVectors[i].dot(a.vertex(j)));
            foreignProjections.push(testVectors[i].dot(b.vertex(j)));
        }

        // Loop through foreignProjections, and test if each point is x lt my.min AND x gt m.max
        // If it's in the range, add this vertex to a list
        for (var k in foreignProjections) {
            if (foreignProjections[k] > myProjections.min() && foreignProjections[k] < myProjections.max()) {
                bInvolvedVertices[i].push(b.vertex(k));
            }
        }

        // Loop through myProjections and test if each point is x gt foreign.min and x lt foreign.max
        // If it's in the range, add the vertex to the list
        for (var p in myProjections) {
            if (myProjections[p] > foreignProjections.min() && myProjections[p] < foreignProjections.max()) {
                aInvolvedVertices[i].push(a.vertex(p));
            }
        }
    }

    // console.log( intersect_safe ( intersect_safe( involvedVertices[0], involvedVertices[1] ), intersect_safe( involvedVertices[2], involvedVertices[3] ) ) );
    aInvolvedVertices = intersect_safe(intersect_safe(aInvolvedVertices[0], aInvolvedVertices[1]), intersect_safe(aInvolvedVertices[2], aInvolvedVertices[3]));
    bInvolvedVertices = intersect_safe(intersect_safe(bInvolvedVertices[0], bInvolvedVertices[1]), intersect_safe(bInvolvedVertices[2], bInvolvedVertices[3]));
    /*
     If we have two vertices from one rect and one vertex from the other, probably the single vertex is penetrating the segment
     return involvedVertices;
     */

    if (aInvolvedVertices.length === 1 && bInvolvedVertices.length === 2) {
        return aInvolvedVertices[0];
    }
    else if (bInvolvedVertices.length === 1 && aInvolvedVertices.length === 2) {
        return bInvolvedVertices[0];
    }
    else if (aInvolvedVertices.length === 1 && bInvolvedVertices.length === 1) {
        return aInvolvedVertices[0];
    }
    else if (aInvolvedVertices.length === 1 && bInvolvedVertices.length === 0) {
        return aInvolvedVertices[0];
    }
    else if (aInvolvedVertices.length === 0 && bInvolvedVertices.length === 1) {
        return bInvolvedVertices[0];
    }
    else if (aInvolvedVertices.length === 0 && bInvolvedVertices.length === 0) {
        return false;
    }
    else {
        console.log("Unknown collision profile");
        console.log(aInvolvedVertices);
        console.log(bInvolvedVertices);
        clearInterval(timer);
    }


    return true;

};

var rect = new Rect(200, 0, 100, 50);
var wall = new Rect(0, 800, 800, 10);
var wall1 = new Rect(0, 0, 10, 800);

rect.omega = -10;

var collisionCount = 0;

var loop = function () {
    var f = new V(0, 0);
    var torque = 0;

    /* Start Velocity Verlet by performing the translation */
    var dr = rect.v.scale(dt).add(rect.a.scale(0.5 * dt * dt));
    rect.move(dr.scale(100));

    /* Add Gravity */
    f = f.add(new V(0, rect.m * 9.81));

    /* Add damping */
    f = f.add(rect.v.scale(b));

    /* Handle collision */
    var collision = satTest(rect, wall);
    if (collision) {
        collisionCount++;
        console.log(collisionCount);

        if(collisionCount >= 4) {
            console.log(collisionCount);
            var N = rect.center(); //.rotate(Math.PI , new V(0,0));
            N = N.scale(1 / N.length());
            var Vr = rect.v;
            rect.v = N.scale(-1  * Vr.dot(N));
            rect.omega = 0;
            rect.theta = 0;
        } else {
            var N = rect.center().subtract(collision).rotate(Math.PI , new V(0,0)); //.rotate(Math.PI , new V(0,0));
            N = N.scale(1 / N.length());
            var Vr = rect.v;
            rect.v = N.scale(-1 * (1 + 0.3) * Vr.dot(N));
            rect.omega = -1 * 0.2 * (rect.omega / Math.abs(rect.omega)) * rect.center().subtract(collision).cross(Vr);
        }
    }

    var collision1 = satTest(rect, wall1);
    if (collision1) {
        var N = rect.center().subtract(collision1).rotate(Math.PI , new V(0,0)); //.rotate(Math.PI , new V(0,0));
        N = N.scale(1 / N.length());
        var Vr = rect.v;
        rect.v = N.scale(-1 * (1 + 0.3) * Vr.dot(N));
        rect.omega = -1 * 0.2 * (rect.omega / Math.abs(rect.omega)) * rect.center().subtract(collision1).cross(Vr);
    }


    if (collisionCount <=10) { /* Finish Velocity Verlet */
        var new_a = f.scale(rect.m);
        var dv = rect.a.add(new_a).scale(0.5 * dt);
        rect.v = rect.v.add(dv);

        /* Do rotation; let's just use Euler for contrast */
        torque += rect.omega * angularB; // Angular damping
        rect.alpha = torque / rect.J;
        rect.omega += rect.alpha * dt;
        var deltaTheta = rect.omega * dt;
        rect.rotate(deltaTheta);
    } else {
        var deltaTheta = rect.omega * dt;
        rect.rotate(deltaTheta);
    }

    draw();
};

var draw = function () {
    ctx.clearRect(0, 0, width, height);
    rect.draw(ctx);
    wall.draw(ctx);
    wall1.draw(ctx);
};

var timer;

canvas = document.getElementById('canvas');
ctx = canvas.getContext('2d');
ctx.strokeStyle = 'black';
timer = setInterval(loop, dt * 1000);

