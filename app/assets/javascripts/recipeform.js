var section_queue = [2, 3, 4, 5];

var addIngredient = function (n) {
    var section_ingredients = document.getElementById('ingredients' + n);
    var ingredients_size = section_ingredients.getElementsByClassName("row").length;

    if (ingredients_size < 15) {
        var div = createDiv("row");
        section_ingredients.appendChild(div);

        var div1 = createDiv("col-md-1");
        var div2 = createDiv("col-md-1");
        var div3 = createDiv("col-md-1");
        var div4 = createDiv("col-md-1");
        div.appendChild(div1);
        div.appendChild(div2);
        div.appendChild(div3);
        div.appendChild(div4);

        var input1 = createtInput("text", "subsection_ingredient_amount", "amount");
        div1.appendChild(input1);

        var select = createSelect();
        div2.appendChild(select);

        var input3 = createtInput("text", "ingredient_name", "ingredient");
        div3.appendChild(input3);

        var button = createRemoveButton();
        div4.appendChild(button);
    }
};

var createDiv = function (className) {
    var div = document.createElement("div");
    div.className = className;

    return div
}

var createtInput = function (type, id, placeholder) {
    var input = document.createElement("input");
    input.type = type;
    input.id = id;
    input.placeholder = placeholder;

    return input
};

var createSelect = function () {
    var select = document.createElement("select");
    select.id = "subsection_ingredient_unit";
    select.name = "subsection_ingredient[unit]";
    var units = ["dl", "l", "g", "kg", "tbsp", "tsp", "-", "pcs", "cups"];
    units.forEach(function (item) {
        var option = document.createElement("option");
        option.innerHTML = item;
        select.appendChild(option)
    });

    return select
};

var createRemoveButton = function () {
    var button = document.createElement("button");
    button.type = "button";
    button.className = "btn btn-default r";
    var span = document.createElement("span");
    span.className = "glyphicon glyphicon-remove";
    button.appendChild(span);

    return button
};

var addSubsection = function () {
    if (section_queue.length > 0) {
        var section_i = section_queue.shift();
        var div = createDiv("subsection");
        div.id = "subsection" + section_i;
        document.getElementById('subsections').appendChild(div);

        var div_title = document.createElement("div"),
            text = document.createTextNode("Section");
        div_title.className = "field";

        div.appendChild(div_title);

        div_title.appendChild(text);
        div_title.appendChild((document.createElement("br")));

        var input = createtInput("text", "subsection_title" + section_i, "Section");
        input.className = "subsection_title";
        div_title.appendChild(input);

        var button_r = createRemoveButtonWithText(" Section and its ingredients", "remove", "btn btn-default r", "glyphicon glyphicon-remove");

        div_title.appendChild(button_r);
        div_title.appendChild((document.createElement("br")));

        var div_ingredients = document.createElement("div");
        div_ingredients.id = "ingredients" + section_i;
        div_ingredients.className = "ingredients";

        div.appendChild(div_ingredients);

        addIngredient(section_i);

        var button = createAddIngButtonWithText("Ingredient", "addI", section_i, "btn btn-default i", "glyphicon glyphicon-plus");

        div.appendChild(button)
    }
};

var createRemoveButtonWithText = function (text, id, className, spanClassname) {
    var button = document.createElement("button"),
        text = document.createTextNode(text);
    button.type = "button";
    button.id = id;
    button.className = className;

    var span = document.createElement("span");
    span.className = spanClassname;

    button.appendChild(span);
    button.appendChild(text);

    return button
};

var createAddIngButtonWithText = function (text, id, index, classname, spanClassname) {
    var button = document.createElement("button"),
        text = document.createTextNode(text);
    button.type = "button";
    button.id = id + index;
    button.className = classname;

    var span = document.createElement("span");
    span.className = spanClassname;

    button.appendChild(span);
    button.appendChild(text);

    return button
};

Object.size = function (obj) {
    var size = 0;
    for (var key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};

var error_count = function (errors) {
    var count = 0;
    for (var key1 in errors) {
        for (var key2 in errors[key1]) {
            for (var key3 in errors[key1][key2]) {
                if (Object.size(errors[key1])) {
                    count++;
                }
            }
        }
    }
    return count;
};

var showErrors = function (errors) {
    $('html, body').animate({scrollTop: 0}, 'fast');

    if (document.getElementById("errors").childElementCount > 0) {
        document.getElementById('error_explanation').remove()
    }

    var div = document.createElement("div");
    div.id = "error_explanation";
    document.getElementById('errors').appendChild(div);

    var h2 = document.createElement("h2"),
        text = document.createTextNode(error_count(errors) + " error(s) probited this recipe from being saved");
    h2.appendChild(text);
    document.getElementById('error_explanation').appendChild(h2);

    var ul = document.createElement("ul");
    ul.id = "error_ul";
    document.getElementById('error_explanation').appendChild(ul);

    for (var key1 in errors) {
        for (var key2 in errors[key1]) {
            for (var key3 in errors[key1][key2]) {
                if (Object.size(errors[key1])) {
                    var li = document.createElement("li"),
                        text = document.createTextNode(key1 + " " + key3 + " " + errors[key1][key2][key3]);
                    li.appendChild(text);
                    document.getElementById('error_ul').appendChild(li);
                }
            }
        }
    }
};

var errorFunction = function (data) {
    var mistakes = {};

    mistakes.recipe = data.responseJSON.recipe_errors;
    mistakes.subsection = data.responseJSON.subsection_errors;
    mistakes.amount_unit = data.responseJSON.si_errors;
    mistakes.ingredient = data.responseJSON.ingredient_errors;

    showErrors(mistakes)
};

var rowForEach = function ($subsection, sub) {
    var ings_a = [];

    $subsection.find(".row").each(function () {
        var ingredient = {};
        ingredient.amount = $(this).find("#subsection_ingredient_amount").val();
        ingredient.unit = $(this).find("#subsection_ingredient_unit").val();
        ingredient.name = $(this).find("#ingredient_name").val();
        ings_a.push(ingredient);
        sub.ings = ings_a
    });

    return sub
};

$(document).on('click', ".btn.btn-default.i", function () {
    button_id = this.id;
    id = parseInt(button_id.charAt(button_id.length - 1), 10);
    addIngredient(id)
});

$(document).on('click', ".btn.btn-default.r", function () {
    var p = this.parentElement.parentElement;
    if (p.id.substring(0, p.id.length - 1) == "subsection") {
        var ind = parseInt(p.id.charAt(p.id.length - 1), 10);
        if ($.inArray(ind, section_queue) == -1)
            section_queue.push(ind)
    }
    p.remove()
});

$(document).on('turbolinks:load', function () {

    var subs_num = $(".edit_recipe").find("[class=subsection]").length;
    if (subs_num != 0) {
        section_queue.unshift(1)
    }
    for (i = 0; i < subs_num; i++) {
        section_queue.shift()
    }

    $("#addS").click(function (e) {
        addSubsection();
    });

    $("#create_recipe").on("click", function (event) {
        event.preventDefault();

        var form = $(".actions").parent();

        var recipe = {};

        recipe.name = form.find("#recipe_name").val();
        recipe.amount = form.find("#recipe_amount").val();
        recipe.time_h = form.find("#recipe_time_h").val();
        recipe.time_min = form.find("#recipe_time_min").val();

        var subs = form.find("[class=subsection]");
        var subs_a = [];
        subs.each(function () {
            var $this = $(this);
            var sub = {};
            var title = $this.find(".subsection_title").val();
            if (title == undefined) {
                title = "";
            }
            sub.title = title;

            sub = rowForEach($this, sub);
            subs_a.push(sub)
        });

        recipe.subsections = subs_a;

        recipe.description = form.find("#recipe_description").val();

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
                errorFunction(data)
            }
        });
    });

    $("#edit_recipe").on("click", function (event) {
        event.preventDefault();
        var form = $(".actions").parent();

        var recipe = {};

        recipe.id = form.find("#recipe_id").val();
        recipe.amount = form.find("#recipe_amount").val();
        recipe.time_h = form.find("#recipe_time_h").val();
        recipe.time_min = form.find("#recipe_time_min").val();

        var subs = form.find("[class=subsection]");
        var subs_a = [];

        subs.each(function (i) {
            var $this = $(this);
            var sub = {};
            var title = $this.find("#subsection_title").val();
            if (title == undefined) {
                title = $this.find(".subsection_title").val();
            }

            if (title == undefined) {
                title = "";
            }
            sub.title = title;

            sub = rowForEach($this, sub);
            subs_a.push(sub)
        });

        recipe.subsections = subs_a;

        recipe.description = form.find("#recipe_description").val();

        jQuery.ajax({
            url: "/recipes/" + recipe.id,
            type: "PUT",
            data: JSON.stringify({data: recipe}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                if (data.location) {
                    window.location.replace(data.location);
                }
            },
            error: function (data) {
                errorFunction(data)
            }
        });
    });
});
