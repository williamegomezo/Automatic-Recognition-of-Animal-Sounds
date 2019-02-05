import { combineReducers, createStore } from 'redux';

import plotReducer from './reducers/plotReducer';
import tableReducer from './reducers/tableReducer';
import dirReducer from './reducers/dirReducer';

const rootReducer = combineReducers({
  tableReducer,
  plotReducer,
  dirReducer
});

const store = createStore(rootReducer);

export default store;
