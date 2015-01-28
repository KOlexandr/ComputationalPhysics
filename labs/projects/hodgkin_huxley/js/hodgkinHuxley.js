var HodgkinHuxley = function(c, gk, gna, gl, vk, vna, vl, v0) {
    this.dt = 0.025;
    this.c = c;
    this.gk = gk;
    this.gna = gna;
    this.gl = gl;
    this.vk = vk;
    this.vna = vna;
    this.vl = vl;

    this.v = v0;
    this.n = 0.32;
    this.m = 0.05;
    this.h = 0.60;
    this.electricityPowerInjection = 0;

    function alphaN(v) {
        if (v === 10) {
            return alphaN(v + 0.001);
        } else {
            return (10 - v) / (100 * (Math.exp(1 - v / 10) - 1));
        }
    }

    function betaN(v) {
        return 0.125 * Math.exp(-v / 80);
    }

    function alphaM(v) {
        if (v === 25) {
            return alphaM(v + 0.001);
        } else {
            return (25 - v) / (10 * (Math.exp(2.5 - v / 10) - 1));
        }
    }

    function betaM(v) {
        return 4 * Math.exp(-v / 18)
    }

    function alphaH(v) {
        return 0.07 * Math.exp(-v / 20);
    }

    function betaH(v) {
        return 1 / (Math.exp(3 - v / 10) + 1);
    }

    this.step = function () {
        var aN = alphaN(this.v);
        var bN = betaN(this.v);
        var aM = alphaM(this.v);
        var bM = betaM(this.v);
        var aH = alphaH(this.v);
        var bH = betaH(this.v);

        var tauN = 1 / (aN + bN);
        var tauM = 1 / (aM + bM);
        var tauH = 1 / (aH + bH);
        var nInf = aN * tauN;
        var mInf = aM * tauM;
        var hInf = aH * tauH;

        this.n += this.dt / tauN * (nInf - this.n);
        this.m += this.dt / tauM * (mInf - this.m);
        this.h += this.dt / tauH * (hInf - this.h);
        var ina = this.gna * this.m * this.m * this.m * this.h * (this.vna - this.v);
        var ik = this.gk * this.n * this.n * this.n * this.n * (this.vk - this.v);
        var il = this.gl * (this.vl - this.v);

        this.v += this.dt / this.c * (ina + ik + il + this.electricityPowerInjection);
    };
};

var initialize = function(){
    $.plot("#hodgkinHuxley", [[]], {
        xaxis: {min: 0, max: 200},
        yaxis: {min: -50, max: 150},
        colors: ['#000000', '#FF0000']
    });
    $("label").tooltip();
    $("button").click(function() {
        $("#errorDiv").html("");
    });
    $("#start").click(function () {
        /* Parameters */
        var c = parseFloat($("#c").val());
        var gk = parseFloat($("#gk").val());
        var gi = parseFloat($("#gi").val());
        var vk = parseFloat($("#vk").val());
        var vi = parseFloat($("#vi").val());
        var v0 = parseFloat($("#v0").val());
        var gna = parseFloat($("#gna").val());
        var vna = parseFloat($("#vna").val());

        var iterationNumbers = parseFloat($("#iterationNumbers").val());
        var timeInjectionStop = parseFloat($("#timeInjectionStop").val());
        var timeInjectionStart = parseFloat($("#timeInjectionStart").val());
        var electricityPowerStep = parseFloat($("#electricityPowerStep").val());

        var IDC = parseFloat($("#idc").val());
        var IRand = parseFloat($("#iRand").val());

        var plot = $.plot("#hodgkinHuxley", [
                {data: [[]], label: "Membrane Voltage (mV)"},
                {data: [[]], label: "Injected Current (nA/cm^2)"}
            ], {
                xaxis: {min: 0, max: iterationNumbers},
                yaxis: {min: -50, max: 150},
                colors: ['#000000', '#FF0000']
            });

        var hodgkinHuxley = new HodgkinHuxley(c, gk, gna, gi, vk, vna, vi, v0);

        var membranePotentialValues = new Array(Math.floor(iterationNumbers / hodgkinHuxley.dt));
        var electricityPowerValues = new Array(Math.floor(iterationNumbers / hodgkinHuxley.dt));
        // sample rate of simulation data to generate plotting data
        var plotSampleRate = Math.ceil(iterationNumbers / 2000 / hodgkinHuxley.dt);
        var i = 0;
        var rawInjection = 0;
        for (var t = 0; t < iterationNumbers; t += hodgkinHuxley.dt) {
            if (t > timeInjectionStart && t < timeInjectionStop) {
                rawInjection = IDC + IRand * 2 * (Math.random() - 0.5);
            } else {
                rawInjection = 0;
            }
            hodgkinHuxley.electricityPowerInjection += hodgkinHuxley.dt / electricityPowerStep * (rawInjection - hodgkinHuxley.electricityPowerInjection);
            hodgkinHuxley.step();
            if (i == plotSampleRate) {
                membranePotentialValues.push([t, hodgkinHuxley.v]);
                electricityPowerValues.push([t, hodgkinHuxley.electricityPowerInjection]);
                i = 0;
            }
            i++;
        }
        if (isNaN(membranePotentialValues[membranePotentialValues.length - 1][1])) {
            $('#errorDiv').html("Simulation produced NaN, probably numerical instability or bug");
        } else {
            $('#errorDiv').html("");
        }
        plot.setData([membranePotentialValues, electricityPowerValues]);
        plot.draw();
    });
};