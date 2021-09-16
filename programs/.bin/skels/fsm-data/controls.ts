import {
	select,
	dispatch,
	apiFetch,
	controls as dataControls,
} from '@wordpress/data-controls';


type AwaitPromiseAction< T > = {
	readonly type: 'NELIO_AWAIT_PROMISE';
	readonly promise: Promise< T >;
};

function awaitPromise< T >( promise: Promise< T > ): AwaitPromiseAction< T > {
	return {
		type: 'NELIO_AWAIT_PROMISE',
		promise,
	};
} //end awaitPromise()

function awaitPromiseControl< T >( action: AwaitPromiseAction< T > ): Promise< T > {
	return action.promise;
} //end awaitPromiseControl()

const controls = {
	...dataControls,
	NELIO_AWAIT_PROMISE: awaitPromiseControl,
};

export {
	apiFetch,
	awaitPromise,
	controls,
	dispatch,
	select,
};
