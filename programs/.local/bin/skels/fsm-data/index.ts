import { registerStore } from '@wordpress/data';

import { STORE } from './config';
import { controls } from './controls';
import { reducer } from './reducer';

import * as realActions from './actions';
import * as selectors from './selectors';
import * as sideEffects from './side-effects';

const actions = { ...realActions, ...sideEffects };

export type Actions = RemoveAction< typeof actions >;
export type Selectors = RemoveState< typeof selectors >;

export { STORE };

declare module '@wordpress/data' {
	function dispatch( key: typeof STORE ): Actions;
	function select( key: typeof STORE ): Selectors;

	// NOTICE: This should be defined in @types/wordpress__data
	export function resolveSelect(
		storeKey: string,
		selectorName: string,
		...args: any[] // eslint-disable-line
	): void;
}

registerStore( STORE, {
	reducer,
	actions: { ...realActions, ...sideEffects },
	selectors,
	controls,
} );

// ============
// HELPER TYPES
// ============

type RemoveState< R > = OmitFirstArgs< R >;
type RemoveAction< R > = RemoveReturnTypes< R >;

type OmitFirstArg< F > = F extends ( x: any, ...args: infer P ) => infer R
	? ( ...args: P ) => R
	: never;

type OmitFirstArgs< R extends Record< string, any > > = {
	readonly [ K in keyof R ]: OmitFirstArg< R[ K ] >;
};

type RemoveReturnType< F > = F extends ( ...args: infer P ) => any
	? ( ...args: P ) => void
	: never;

type RemoveReturnTypes< R extends Record< string, any > > = {
	readonly [ K in keyof R ]: RemoveReturnType< R[ K ] >;
};
