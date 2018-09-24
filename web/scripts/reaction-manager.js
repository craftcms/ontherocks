class HUD {
    constructor(anchor, element) {
        this.$anchor = $(anchor);
        this.$element = $(element);

        $(document.body)
            .on('click', $.proxy(this, 'hide'))
            .on('keypress', function(e) {
                console.log(e.keyCode);
            });


        this.$anchor.on('click', $.proxy(function(e) {
            e.stopPropagation();
            e.preventDefault();
            this.toggle();
        }, this));

        this.$element.on('click', function(e) {
            e.stopPropagation();
        });
    }

    onShow(callback) {
        this.showCallback = callback;
        return this;
    }

    onHide(callback) {
        this.hideCallback = callback;
        return this;
    }

    show() {
        this.visible = true;
        this.$element.appendTo(document.body);
        this.position();
        if (this.showCallback) {
            this.showCallback();
        }
    }

    hide() {
        this.visible = false;
        this.$element.detach();
        if (this.hideCallback) {
            this.hideCallback();
        }
    }

    toggle() {
        if (this.visible) {
            this.hide();
        } else {
            this.show();
        }
    }

    position() {
        var anchorOffset = this.$anchor.offset();
        this.$element.css({
            top: anchorOffset.top + this.$anchor.height() + 5,
            left: anchorOffset.left - 3
        });
    }
}

class ReactionManager {
    constructor(container) {
        this.$container = $(container);
        this.recipeId = this.$container.data('recipe-id');
        this.reactions = {};
        this.reactionToggles = {};

        var that = this;

        $('.reaction', this.$container).each(function() {
            that.initReaction(this);
        });

        this.$addBtn = $('.add-reaction', this.$container);

        this.createHud();
    }

    initReaction(element) {
        var reaction = new Reaction(this, element);
        this.reactions[reaction.emoji] = reaction;
    }

    add(emoji) {
        this.runAjaxRequest(emoji, 'add');

        if (!this.reactions[emoji]) {
            // add the reaction
            var $element = $(
                '<a class="reaction interactive">' +
                    '<span class="emoji">' + emoji + '</span>' +
                    '<span class="count">1</span>' +
                '</a>');
            $element.data('users', window.username);
            $element.insertBefore(this.$addBtn);
            this.initReaction($element);
            initReactions($element);
        } else {
            // update the reaction
            this.reactions[emoji].users.push(window.username);
            this.reactions[emoji].selectStyle();
            this.reactions[emoji].modifyCount(1);
        }

        this.reactionToggles[emoji].selectStyle();
        this.hud.hide();
    }

    remove(emoji) {
        this.runAjaxRequest(emoji, 'remove');

        // if this was the last of its kind, remove it
        if (this.reactions[emoji].count === 1) {
            this.reactions[emoji].$element.remove();
            delete this.reactions[emoji];
        } else {
            var index = $.inArray(window.username, this.reactions[emoji].users);
            this.reactions[emoji].users.splice(index, 1);
            this.reactions[emoji].deselectStyle();
            this.reactions[emoji].modifyCount(-1);
        }

        this.reactionToggles[emoji].deselectStyle();
        this.hud.hide();
    }

    runAjaxRequest(emoji, action) {
        $.post({
            url: '',
            data: {
                action: 'on-the-rocks/reactions/' + action,
                recipeId: this.recipeId,
                reaction: emoji,
            },
            headers: {
                'X-CSRF-Token': window.csrfTokenValue
            }
        });
    }

    createHud() {
        var $hud = $('<div class="absolute rounded border border-grey-light shadow p-4 bg-white text-white z-10 flex"/>');
        var emojis = ['❤️', '😂', '🙌', '👍', '👎', '😐', '😵', '🤮'];
        var $toggle;

        for (var i = 0; i < emojis.length; i++) {
            $toggle = $('<div/>', {
                'class': 'p-2 hover:bg-grey-lighter rounded-sm cursor-pointer text-2xl',
                text: emojis[i]
            }).appendTo($hud);

            this.reactionToggles[emojis[i]] = new ReactionToggle(this, emojis[i], $toggle);
        }

        var that = this;

        this.hud = (new HUD(this.$addBtn, $hud))
            .onShow(function() {
                that.$addBtn.addClass('text-orange-dark');
            })
            .onHide(function() {
                that.$addBtn.removeClass('text-orange-dark');
            });
    }

    isReactionSelected(emoji) {
        return this.reactions[emoji] && this.reactions[emoji].isSelected();
    }
}

class Reaction {
    constructor(manager, element) {
        this.manager = manager;
        this.$element = $(element);
        this.$count = this.$element.children('.count');
        this.users = this.$element.data('users').split(',');
        this.emoji = this.$element.children('.emoji').text();
        this.count = this.users.length;


        if (window.username) {
            if (this.isSelected()) {
                this.selectStyle();
            }

            this.$element.addClass('cursor-pointer');
            this.$element.on('click', $.proxy(this, 'toggle'));
        }
    }

    isSelected() {
        return $.inArray(window.username, this.users) !== -1;
    }

    selectStyle() {
        this.$element.addClass('bg-grey-lighter');
    }

    deselectStyle() {
        this.$element.removeClass('bg-grey-lighter');
    }

    modifyCount(mod) {
        this.count += mod;
        this.$count.text(this.count);
    }

    toggle() {
        if (this.isSelected()) {
            this.manager.remove(this.emoji);
        } else {
            this.manager.add(this.emoji);
        }
    }
}

class ReactionToggle {
    constructor(manager, emoji, toggle) {
        this.manager = manager;
        this.emoji = emoji;
        this.$toggle = $(toggle);

        if (this.isSelected()) {
            this.selectStyle();
        }

        this.$toggle.on('click', $.proxy(this, 'toggle'));
    }

    isSelected() {
        return this.manager.isReactionSelected(this.emoji);
    }

    selectStyle() {
        this.$toggle.addClass('bg-grey-lighter');
    }

    deselectStyle() {
        this.$toggle.removeClass('bg-grey-lighter')
    }

    toggle() {
        if (this.isSelected()) {
            this.manager.remove(this.emoji);
        } else {
            this.manager.add(this.emoji);
        }
    }
}

$('.reactions').each(function() {
    new ReactionManager(this);
});

$('.add-reaction').each(function() {
    
});
