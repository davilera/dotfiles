import type { State } from './types/state';

export function getValue( state: State ): string {
	return 'one-state' === state.status ? state.value : '';
} //end getValue()
