import type { State } from './types';
import { Action } from './actions';

import { INIT_STATE } from './config';

type AnyAction = {
	readonly type: string;
};

export function reducer( state: State = INIT_STATE, action: AnyAction ): State {
	return actualReducer( state, action as Action ) ?? state;
} //end reducer()

function actualReducer( state: State, action: Action ): State {
	switch ( action.type ) {
		case 'SET_VALUE':
			return {
				...state,
				value: action.value,
			};
	} //end switch
} //end actualReducer()
