/*
 * Replace all SVG images with inline SVG
 * http://stackoverflow.com/questions/24933430/img-src-svg-changing-the-fill-color
 */
function replace_img_svg_with_inline($img){
    var imgID = $img.attr('id');
    var imgClass = $img.attr('class');
    var imgURL = $img.attr('src');

    console.log('replace_img_svg_with_inline: requesting from ' + imgURL);

    // Ajax callback
    jQuery.get(imgURL, function(data) {

        console.log('replace_img_svg_with_inline: received response, parsing');

        // Get the SVG tag, ignore the rest
        var $svg = jQuery(data).find('svg');

        // Add replaced image's ID to the new SVG
        if(typeof imgID !== 'undefined') {
            $svg = $svg.attr('id', imgID);
        }
        // Add replaced image's classes to the new SVG
        if(typeof imgClass !== 'undefined') {
            $svg = $svg.attr('class', imgClass+' replaced-svg');
        }

        // Remove any invalid XML tags as per http://validator.w3.org
        $svg = $svg.removeAttr('xmlns:a');

        // Check if the viewport is set, if the viewport is not set the SVG wont't scale.
        if(!$svg.attr('viewBox') && $svg.attr('height') && $svg.attr('width')) {
            $svg.attr('viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width'))
        }

        // Replace image with new SVG
        $img.replaceWith($svg);

    }, 'xml');
}

function replace_img_svgs_with_inline() {
    console.log('replace_img_svgs_with_inline');
    jQuery('img.svg').each(function(){
        replace_img_svg_with_inline(jQuery(this))
    });
}


$(document).on('page:change', replace_img_svgs_with_inline);