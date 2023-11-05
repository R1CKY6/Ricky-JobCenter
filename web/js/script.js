const app = new Vue({
    el: '#app',

    data: {

        nomeRisorsa : GetParentResourceName(),

        jobs : [],

        currentJob : 'pescatore',

        textKey : 0,

        name : '',

        avatar : false,

        config : {
            lang : {}
        }
    },

    methods: {
        postMessage(type, data) {
            $.post(`http://${this.nomeRisorsa}/${type}`, JSON.stringify(data))
        },

        getSelected(job) {
            if(job == this.currentJob) {
                return this.config.lang.selected;
            } else {
                return this.config.lang.select;
            }
        },

        changeJob(job) {
            if(job == this.currentJob) return
            this.postMessage('changeJob', {
                job : job
            })
        }
    }

});


window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {
        $("#app").fadeIn(500)
        app.jobs = data.jobs
        app.currentJob = data.myJob
        app.name = data.name
        if(!data.avatar) {
            app.avatar = "./img/tech.png"
        } else {
            app.avatar = data.avatar
        }
    } else if(data.type === "UPDATE_CURRENTJOB") {
        app.currentJob = data.myJob
        app.textKey += 1
    } else if(data.type === "SET_CONFIG") {
        app.config = data.config
        app.config.lang = app.config.Lang[app.config.Language]
    }
})

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        $("#app").fadeOut(500)
        app.postMessage('close')
        return
    }
};
