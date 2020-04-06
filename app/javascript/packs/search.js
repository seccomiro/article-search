const _ = require('underscore');
const axios = require('axios');

const debounceSearch = _.debounce(async (term, baseUrl) => {
  const url = `${baseUrl}/${term}`;
  const response = await axios.get(url);
  console.log(response.data);
}, 500);

window.onload = (e) => {
  const form = document.querySelector('.search_form');
  const field = document.querySelector('#term');
  const baseUrl = form.getAttribute('action');
  console.log(baseUrl);

  const search = (term) => {
    debounceSearch(term, baseUrl);
  };

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    search(field.value);
  });

  field.addEventListener('keyup', (e) => {
    search(field.value);
  });
};
