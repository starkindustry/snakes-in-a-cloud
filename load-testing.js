import http from 'k6/http';
import { check, group, sleep } from 'k6';

export const options = {

    stages: [
      { duration: '2m', target: 300 }, // around the breaking point
      { duration: '5m', target: 500 }, // beyond the breaking point
      { duration: '2m', target: 400 }, // down a skosh
      { duration: '10m', target: 0 }, // scale down. Recovery stage.
    ],
  };


  export default function () {
    const BASE_URL = 'https://snakes-app.snakesinacloud-staging-starkindustry.com/hello/rewind';
    const responses = http.batch([
      ['GET', `${BASE_URL}/hello/paul/`, null, null],
      ['GET', `${BASE_URL}/hello/ringo/`, null, null],
      ['GET', `${BASE_URL}/hello/george/`, null, null],
      ['GET', `${BASE_URL}/hello/john/`, null, null],
    ]);

    sleep(1);
  }