var search = document.getElementById('search');
var textEvents = ['change', 'keydown', 'keyup', 'keypress'];
var searchVal = search.value;
var searchTimeout;

for (var i = 0; i < textEvents.length; i++) {
    search.addEventListener(textEvents[i], checkSearchValue);
}

function checkSearchValue() {
    if (searchVal !== (searchVal = search.value)) {
        if (searchTimeout) {
            clearTimeout(searchTimeout);
        }
        searchTimeout = setTimeout(applyFilters, 250);
    }
}

var ingredientFilter = document.getElementById('ingredient-filter');
ingredientFilter.addEventListener('change', applyFilters);

function applyFilters() {
    $('#recipe-list').load('/?search=' + encodeURIComponent(searchVal) +
        '&ingredient=' + ingredientFilter.value +
        ' #recipe-list > div');
}
