const _ = require('underscore');
const axios = require('axios');

const debounceSearch = _.debounce(async (term, baseUrl, submit) => {
  const url = `${baseUrl}/${term}`;
  const response = await axios.get(url, { params: { submit } });
  console.log(response.data);
}, 500);

window.onload = (e) => {
  const form = document.querySelector('.search_form');
  const field = document.querySelector('#term');
  if (!form) return;
  const baseUrl = form.getAttribute('action');
  console.log(baseUrl);

  const search = (term, submit = false) => {
    debounceSearch(term, baseUrl, submit);
  };

  form.addEventListener('submit', (e) => {
    e.preventDefault();
    search(field.value, true);
  });

  let lastValue = '';

  field.addEventListener('focus', (e) => {
    lastValue = field.value;
  });

  field.addEventListener('keyup', (e) => {
    if (field.value.length > 0 && field.value !== lastValue) {
      lastValue = field.value;
      search(field.value);
    }
  });
};
