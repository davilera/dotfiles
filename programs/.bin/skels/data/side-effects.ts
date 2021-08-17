import { select, dispatch } from '@wordpress/data';

import { STORE } from './config';
import { awaitPromise } from './controls';

export type SideEffect = DoSomething;

type DoSomething = {
	readonly type: 'AFTER_SIDE_EFFECTS__DO_SOMETHING';
};

export function* doSomething(): Generator {
	try {
		const oldValue = select( STORE ).getValue();
		const newValue = ( yield awaitPromise(
			( async () => 'new-value' )()
		) ) as string;
		dispatch( STORE ).setValue( oldValue + newValue );
	} catch ( e ) {
		// Nothing to do here.
	} //end try

	return {
		type: 'AFTER_SIDE_EFFECTS__DO_SOMETHING',
	};
} //end doSomething()
