var addIngredient = function () {
    var div = document.createElement("div");
    div.className = "row";
    document.getElementById('ingredients').appendChild(div);

    var div1 = document.createElement("div");
    div1.className = "col-md-1";
    var div2 = document.createElement("div");
    div2.className = "col-md-1";
    var div3 = document.createElement("div");
    div3.className = "col-md-1";
    div.appendChild(div1);
    div.appendChild(div2);
    div.appendChild(div3);

    var input1 = document.createElement("input");
    input1.type = "text";
    input1.id = "subsection_ingredient_amount";
    div1.appendChild(input1);

    var input2 = document.createElement("input");
    input2.type = "text";
    input2.id = "subsection_ingredient_unit";
    div2.appendChild(input2);

    var input3 = document.createElement("input");
    input3.type = "text";
    input3.id = "subsection_ingredient_amount";
    div3.appendChild(input3);

    document.getElementById('ingredients').appendChild(document.createElement("br"));
};

var addSubsection = function () {
    addIngredient();
};

var printErrors = function(item, index){
    console.log(item)
};

$(document).ready(function () {

    $("#addI").click(function (e){
        addIngredient();
    });

    $("#addS").click(function (e){
        addSubsection();
    });

    $(".actions").on("click", function (event) {
        event.preventDefault();
        var form = $(".actions").parent()

        var recipe = {}

        recipe.name = form.find("#recipe_name").val()
        recipe.amount = form.find("#recipe_amount").val()
        recipe.time_h = form.find("#recipe_time_h").val()
        recipe.time_min = form.find("#recipe_time_min").val()

        // http://stackoverflow.com/questions/6434731/how-to-generate-many-of-the-same-form-fields

        /*
         var subsections_a = [];

         var subsections_html = form.find("[id=subsection]")

         subsections_html.each(function() {
         var s = {}
         s.title = ($(this).find("#subsection_title").val());
         subsections_a.push(s)
         var si_a = [];
         var si_u = [];
         var i = [];
         $(this).find("[id=subsection_ingredient_amount]").each(function() {
         si_a.push($(this).val());
         });
         subsections_a.push(si_a)
         });

         var subsections_a = {}
         subsections_a.title = form.find("#subsection_title").val()

         var list = form.find("#ingredients")

         var si_a = [];

         list.find("[id=subsection_ingredient_amount]").each(function() {
         si_a.push($(this).val());
         });

         var si_u = [];
         list.find("[id=subsection_ingredient_unit]").each(function() {
         si_u.push($(this).val());
         });

         var i = [];
         list.find("[id=ingredient_name]").each(function() {
         i.push($(this).val());
         });

         var subsection_ingredient = {}
         subsection_ingredient.amount = si_a
         subsection_ingredient.unit = si_u
         subsection_ingredient.ingredient = i

         subsections_a.subsection_ingredients = subsection_ingredient
         recipe.subsection = subsections_a
         */

        var subsections = {}
        subsections.title = form.find("#subsection_title").val()

        var subsection_ingredient = {}
        subsection_ingredient.amount = form.find("#subsection_ingredient_amount").val()
        subsection_ingredient.unit = form.find("#subsection_ingredient_unit").val()
        subsection_ingredient.ingredient = form.find("#ingredient_name").val()

        subsections.subsection_ingredients = subsection_ingredient
        recipe.subsection = subsections

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
                var mistakes = data.responseJSON.errors
                for(key in mistakes) {
                    console.log(key + " " + mistakes[key])
                }
                alert("Virhe lomakkeessa");
            }
        });
    });
});
