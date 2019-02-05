import { CHANGE_DIR } from '../actions/action-types';

const initialState = {
  radiosState: {}
};

function dirReducer(state = initialState, action) {
  if (action.type === CHANGE_DIR) {
    return {
      ...state,
      dir: action.payload
    };
  }
  return state;
}

export default dirReducer;
