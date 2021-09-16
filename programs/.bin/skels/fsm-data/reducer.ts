import type { State, OneState, AnotherState } from './types/state';
import type { OneStateAction, AnotherStateAction } from './types/transitions';

import { INIT_STATE } from './config';

type Action = {
	readonly type: string;
};

export function reducer( state: State = INIT_STATE, action: Action ): State {
	switch ( state.status ) {
		case 'one-state':
			return reduceOneState( state, action as OneStateAction ) ?? state;

		case 'another-state':
			return (
				reduceAnotherState( state, action as AnotherStateAction ) ??
				state
			);
	} //end switch
} //end reducer()

function reduceOneState(
	state: OneState,
	action: OneStateAction
): OneState | AnotherState {
	switch ( action.type ) {
		case 'SET_VALUE':
			return {
				...state,
				value: action.value,
			};

		case 'NEXT':
			return {
				status: 'another-state',
			};
	} //end switch
} //end reduceOneState()

function reduceAnotherState(
	state: AnotherState,
	action: AnotherStateAction
): OneState {
	switch ( action.type ) {
		case 'BACK':
			return {
				...state,
				status: 'one-state',
				value: '',
			};
	} //end switch
} //end reduceAnotherState()
