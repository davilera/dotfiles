import { select, dispatch } from '@wordpress/data';

import { STORE } from './config';
import { awaitPromise } from './controls';

type SideEffect = Generator< unknown, void, unknown >;

export function* doSomething(): SideEffect {
	try {
		const oldValue = select( STORE ).getValue();
		const newValue = ( yield awaitPromise(
			( async () => 'new-value' )()
		) ) as string;
		dispatch( STORE ).setValue( oldValue + newValue );
	} catch ( e ) {
		// Nothing to do here.
	} //end try
} //end doSomething()
