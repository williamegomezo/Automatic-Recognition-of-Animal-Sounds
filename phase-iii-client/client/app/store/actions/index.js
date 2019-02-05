import {
  CHANGE_SELECTION,
  CHANGE_RADIO,
  CHANGE_DIR,
  SET_SPECIES
} from './action-types';

export function changeSelection(payload) {
  return { type: CHANGE_SELECTION, payload };
}

export function changeRadio(payload) {
  return { type: CHANGE_RADIO, payload };
}

export function changeDir(payload) {
  return { type: CHANGE_DIR, payload };
}

export function setSpecies(payload) {
  return { type: SET_SPECIES, payload };
}
