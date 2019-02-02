import { CHANGE_RADIO } from '../actions/action-types';

const initialState = {
  radiosState: {}
};

function plotReducer(state = initialState, action) {
  if (action.type === CHANGE_RADIO) {
    return {
      ...state,
      radiosState: { ...state.radiosState, ...action.payload }
    };
  }
  return state;
}

export default plotReducer;
