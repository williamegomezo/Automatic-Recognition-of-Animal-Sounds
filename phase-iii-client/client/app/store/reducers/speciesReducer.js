import { SET_SPECIES } from '../actions/action-types';

const initialState = {
  results: {}
};

function speciesReducer(state = initialState, action) {
  if (action.type === SET_SPECIES) {
    return { ...state, species: action.payload };
  }
  return state;
}

export default speciesReducer;
