$(document).ready(function () {
    console.log("moi")
    $( ".actions" ).on("click", function( event ) {
        event.preventDefault();
        var form = $( ".actions" ).parent()

        var recipe = {}

        recipe.name = form.find("#recipe_name").val()
        recipe.amount = form.find("#recipe_amount").val()
        recipe.time_h = form.find("#recipe_time_h").val()
        recipe.time_min = form.find("#recipe_time_min").val()

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

        jQuery.ajax ({
            url: "/recipes",
            type: "POST",
            data: JSON.stringify({data:recipe}),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function(){
                alert("Jipii");
            }
        });

    });
});
