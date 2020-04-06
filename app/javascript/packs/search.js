const _ = require('underscore');

const debounceSearch = _.debounce((term) => {
  console.log(`Search: ${term}`);
}, 500);

const search = (term) => {
  debounceSearch(term);
};

window.onload = (e) => {
  const form = document.querySelector('.search_form');
  const field = document.querySelector('#term');

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    search(field.value);
  });

  field.addEventListener('keyup', (e) => {
    search(field.value);
  });
};
