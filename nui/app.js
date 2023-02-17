

window.addEventListener('message', function(event) {
    var item = event.data;
    if (item !== undefined && item.type === "ui") {
        if (item.status === true) {
            openMenu(item.jobs)
        } else if (item.status === false) {
            $(".container").hide();
        }
    }
    if (item !== undefined && item.type === "update"){
        openMenu(item.jobs)
    }

})

openMenu = (jobs)=> {
    $('.btn-cont').html('')
    const table =jobs.jobs 
    // for objet table. not lenght not a array
    for (const [key, value] of Object.entries(table)) {
        if (jobs.active == key) {
            $('.btn-cont').append(`
            <button class="btn active" id=${key} onclick="selectJob('${key}')">${value.label}</button>
            `)
            $(`#${key}`).css('background-color' , 'rgba(233, 0, 39, 0.927)')
        } else{
            $('.btn-cont').append(`
            <button class="btn" onclick="selectJob('${key}')">${value.label}</button>
            `)
        }
    }
    $(".container").show();
}

selectJob = (job)=> {
    $.post('https://hn-multijob/selectJob', JSON.stringify(job), (d)=>{
        openMenu(d)
    })
}
