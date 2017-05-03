var section_queue = [2, 3, 4, 5];

var addIngredient = function (n) {
    var section_ingredients = document.getElementById('ingredients' + n);
    var ingredients_size = section_ingredients.getElementsByClassName("row").length
    if (ingredients_size < 15) {
        var div = document.createElement("div");
        div.className = "row";
        section_ingredients.appendChild(div);

        var div1 = document.createElement("div");
        div1.className = "col-md-1";
        var div2 = document.createElement("div");
        div2.className = "col-md-1";
        var div3 = document.createElement("div");
        div3.className = "col-md-1";
        var div4 = document.createElement("div");
        div4.className = "col-md-1";
        div.appendChild(div1);
        div.appendChild(div2);
        div.appendChild(div3);
        div.appendChild(div4);

        var input1 = document.createElement("input");
        input1.type = "text";
        input1.id = "subsection_ingredient_amount";
        input1.placeholder = "amount"
        div1.appendChild(input1);

        var input2 = document.createElement("input");
        input2.type = "text";
        input2.id = "subsection_ingredient_unit";
        input2.placeholder = "unit"
        div2.appendChild(input2);

        var input3 = document.createElement("input");
        input3.type = "text";
        input3.id = "ingredient_name";
        input3.placeholder = "ingredient"
        div3.appendChild(input3);

        var button = document.createElement("button")
        button.type = "button"
        button.className = "btn btn-default r"
        var span = document.createElement("span");
        span.className = "glyphicon glyphicon-remove"
        button.appendChild(span)
        div4.appendChild(button)

        section_ingredients.appendChild(document.createElement("br"));
    }
};

var addSubsection = function () {
    if (section_queue.length > 0) {
        var section_i = section_queue.shift();
        var div = document.createElement("div");
        div.id = "subsection" + section_i;
        div.className = "subsection"
        document.getElementById('subsections').appendChild(div);

        var div_title = document.createElement("div"),
            text = document.createTextNode("Section");
        div_title.className = "field";

        div.appendChild(div_title);

        div_title.appendChild(text);
        div_title.appendChild((document.createElement("br")))

        var input = document.createElement("input");
        input.type = "text";
        input.id = "subsection_title" + section_i;
        input.className = "subsection_title"
        div_title.appendChild(input);

        var button_r = document.createElement("button"),
            text_r = document.createTextNode(" Section and its ingredients");
        button_r.type = "button"
        button_r.id = "remove"
        button_r.className = "btn btn-default r"

        var span_r = document.createElement("span");
        span_r.className = "glyphicon glyphicon-remove"

        button_r.appendChild(span_r)
        button_r.appendChild(text_r)
        div_title.appendChild(button_r)
        div_title.appendChild((document.createElement("br")))

        var div_ingredients = document.createElement("div")
        div_ingredients.id = "ingredients" + section_i
        div_ingredients.className = "ingredients"

        div.appendChild(div_ingredients)

        addIngredient(section_i)

        var button = document.createElement("button"),
            text = document.createTextNode("Ingredient");
        button.type = "button"
        button.id = "addI" + section_i
        button.className = "btn btn-default i"

        var span = document.createElement("span");
        span.className = "glyphicon glyphicon-plus"

        button.appendChild(span)
        button.appendChild(text)
        div.appendChild(button)
    }
};

Object.size = function (obj) {
    var size = 0;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};

var error_count = function (errors) {

};

var showErrors = function (errors) {
    if (document.getElementById("errors").childElementCount > 0) {
        document.getElementById('error_explanation').remove()
    }

    var div = document.createElement("div");
    div.id = "error_explanation"
    document.getElementById('errors').appendChild(div);

    var h2 = document.createElement("h2"),
        text = document.createTextNode("error probited this recipe from being saved");
    h2.appendChild(text)
    document.getElementById('error_explanation').appendChild(h2);

    var ul = document.createElement("ul");
    ul.id = "error_ul"
    document.getElementById('error_explanation').appendChild(ul);

    for (key1 in errors) {
        for (key2 in errors[key1]) {
            if (Object.size(errors[key1])) {
                var li = document.createElement("li"),
                    text = document.createTextNode(key1 + " " + key2 + " " + errors[key1][key2])
                li.appendChild(text)
                document.getElementById('error_ul').appendChild(li);
            }
        }
    }
};

$(document).on('click', ".btn.btn-default.i", function () {
    button_id = this.id
    id = parseInt(button_id.charAt(button_id.length - 1))
    addIngredient(id)
});

$(document).on('click', ".btn.btn-default.r", function () {
    var p = this.parentElement.parentElement
    if (p.id.substring(0, p.id.length - 1) == "subsection") {
        var ind = parseInt(p.id.charAt(p.id.length - 1))
        if ($.inArray(ind, section_queue) == -1)
            section_queue.push(ind)
    }
    p.remove()
});

$(document).on('turbolinks:load', function () {

    $("#addS").click(function (e) {
        addSubsection();
    });

    $("#create_recipe").on("click", function (event) {
        event.preventDefault();
        var form = $(".actions").parent()

        var recipe = {}

        recipe.name = form.find("#recipe_name").val()
        recipe.amount = form.find("#recipe_amount").val()
        recipe.time_h = form.find("#recipe_time_h").val()
        recipe.time_min = form.find("#recipe_time_min").val()

        var subs = form.find("[class=subsection]")
        var subs_a = []
        subs.each(function (i) {
            var $this = $(this)
            var sub = {}
            var title = $this.find(".subsection_title").val();
            sub.title = title
            ings_a = []
            $this.find(".row").each(function (j) {
                var ingredient = {}
                ingredient.amount = $(this).find("#subsection_ingredient_amount").val()
                ingredient.unit = $(this).find("#subsection_ingredient_unit").val()
                ingredient.name = $(this).find("#ingredient_name").val()
                ings_a.push(ingredient)
                sub.ings = ings_a
            })
            subs_a.push(sub)
        });


        var subsections = {}
        subsections.title = form.find("#subsection_title").val()

        var subsection_ingredient = {}
        subsection_ingredient.amount = form.find("#subsection_ingredient_amount").val()
        subsection_ingredient.unit = form.find("#subsection_ingredient_unit").val()
        subsection_ingredient.ingredient = form.find("#ingredient_name").val()

        subsections.subsection_ingredients = subsection_ingredient
        recipe.subsection = subsections

        recipe.subsections = subs_a

        recipe.description = form.find("#recipe_description").val()

        //debugger

        jQuery.ajax({
            url: "/recipes",
            type: "POST",
            data: JSON.stringify({data: recipe}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                if (data.location) {
                    window.location.replace(data.location);
                }
            },
            error: function (data) {
                var mistakes = {}
                mistakes.recipe = data.responseJSON.recipe_errors
                mistakes.subsection = data.responseJSON.subsection_errors
                mistakes.amount_unit = data.responseJSON.si_errors
                mistakes.ingredient = data.responseJSON.ingredient_errors

                showErrors(mistakes)
            }
        });
    });
});
