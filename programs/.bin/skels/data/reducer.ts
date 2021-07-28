import type { State } from './types';
import { Action as ActualAction } from './actions';
import type { SideEffect } from './side-effects';

type Action = ActualAction | SideEffect;
type AnyAction = {
	readonly type: string;
};

const INIT_STATE: State = {
	value: '',
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

		case 'AFTER_SIDE_EFFECTS__DO_SOMETHING':
			return state;
	} //end switch
} //end actualReducer()
