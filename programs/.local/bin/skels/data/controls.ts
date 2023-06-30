import {
	select,
	dispatch,
	apiFetch,
	controls as dataControls,
} from '@wordpress/data-controls';

type AwaitPromiseAction = {
	readonly type: 'NELIO_AWAIT_PROMISE';
	readonly promise: Promise< unknown >;
};

function awaitPromise( promise: Promise< unknown > ): AwaitPromiseAction {
	return {
		type: 'NELIO_AWAIT_PROMISE',
		promise,
	};
} //end awaitPromise()

function awaitPromiseControl( action: unknown ): Promise< unknown > {
	return ( action as AwaitPromiseAction ).promise;
} //end awaitPromiseControl()

const controls = {
	...dataControls,
	NELIO_AWAIT_PROMISE: awaitPromiseControl,
};

export { apiFetch, awaitPromise, controls, dispatch, select };
