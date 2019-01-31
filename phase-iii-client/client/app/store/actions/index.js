import { CHANGE_SELECTION } from './action-types';

export function changeSelection(payload) {
  return { type: CHANGE_SELECTION, payload };
}
