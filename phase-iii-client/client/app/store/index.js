import { combineReducers, createStore } from 'redux';

import plotReducer from './reducers/plotReducer';
import tableReducer from './reducers/tableReducer';
import dirReducer from './reducers/dirReducer';
import speciesReducer from './reducers/speciesReducer';

const rootReducer = combineReducers({
  tableReducer,
  plotReducer,
  dirReducer,
  speciesReducer
});

const store = createStore(rootReducer);

export default store;
