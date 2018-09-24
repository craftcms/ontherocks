var $hud;
var currentElement;
var $currentElement;
var abortRemoveHud = false;

function initReactions(elements) {
    $(elements).on('mouseover', function(e) {
        if (currentElement === e.currentTarget) {
            return;
        }

        currentElement = e.currentTarget;
        $currentElement = $(currentElement);

        if ($hud) {
            $hud.remove();
        }

        $hud = $('<div class="absolute rounded shadow p-2 bg-grey-dark text-white text-xs z-10"/>')
            .appendTo(document.body);
        
        var users = $(e.currentTarget).data('users').split(',');
        for (var i = 0; i < users.length; i++) {
            $('<div/>', {
                text: users[i] === window.username ? 'You' : users[i]
            }).appendTo($hud);
        }
    });
}

$(document.body).on('mousemove', function(e) {
    if ($hud) {
        // is the cursor still over the element?
        var offset = $currentElement.offset();
        if (
            event.pageX >= offset.left &&
            event.pageX <= offset.left + $currentElement.outerWidth() &&
            event.pageY >= offset.top &&
            event.pageY <= offset.top + $currentElement.outerHeight()
        ) {
            $hud.css({
                top: event.pageY,
                left: event.pageX + 12
            });
        } else {
            $hud.remove();
            $hud = currentElement = $currentElement = null;
        }
    }
});

initReactions('.reaction');
