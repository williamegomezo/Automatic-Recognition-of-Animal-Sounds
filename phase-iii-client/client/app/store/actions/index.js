import { CHANGE_SELECTION, CHANGE_RADIO } from './action-types';

export function changeSelection(payload) {
  return { type: CHANGE_SELECTION, payload };
}

export function changeRadio(payload) {
  return { type: CHANGE_RADIO, payload };
}
