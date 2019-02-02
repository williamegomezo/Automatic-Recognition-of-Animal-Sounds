import { combineReducers, createStore } from 'redux';

import plotReducer from './reducers/plotReducer';
import tableReducer from './reducers/tableReducer';

const rootReducer = combineReducers({
  tableReducer,
  plotReducer
});

const store = createStore(rootReducer);

export default store;
