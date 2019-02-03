const base = 'localhost:8000';

export const API_URL = `http://${base}/aureas/`;

export function getData(path, method, body) {
  const url = `${API_URL}${path}`;

  const data = {
    body: JSON.stringify(body),
    mode: 'cors',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    },
    method: method
  };

  return fetch(url, data).then(blob => blob.json());
}
