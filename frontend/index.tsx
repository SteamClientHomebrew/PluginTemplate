import { Millennium, IconsModule, definePlugin, Field, DialogButton, callable } from '@steambrew/client';

class classname {
	static method(country: string, age: number) {
		console.log(`country: ${country}, age: ${age}`);
		return 'method called';
	}
}

// export classname class to global context
Millennium.exposeObj({ classname });

function windowCreated(context: any) {
	// window create event.
	// you can interact directly with the document and monitor it with dom observers
	// you can then render components in specific pages.
	console.log(context);
}

// Declare a function that exists on the backend
const backendMethod = callable<[{ message: string; status: boolean; count: number }], boolean>('test_frontend_message_callback');
// Declare a function that exists on the webkit
// const webkitMethod = callable<[{ message: string; status: boolean; count: number }], string>('webkit:someWebkitMethod');

const SettingsContent = () => {
	return (
		<Field label="Plugin Settings" description="This is a description of the plugin settings." icon={<IconsModule.Settings />} bottomSeparator="standard" focusable>
			<DialogButton
				onClick={() => {
					console.log('Button clicked!');
				}}
			>
				Click Me
			</DialogButton>
		</Field>
	);
};

function hookedSettingsIcon() {
	return {
		SteamButton: (): any => {
			return <IconsModule.Caution height={'20px'} />;
		},
	};
}

Millennium.exposeObj({ hookedSettingsIcon });

export default definePlugin(() => {
	console.log('Calling backendMethod from frontend...');
	backendMethod({
		message: 'Hello World From Frontend!',
		status: true,
		count: 69,
	}).then((message: any) => {
		console.log('Result from backendMethod:', message);
	});

	// /** Give the steam browser some time to load */
	// setTimeout(() => {
	// 	const startTime = performance.now();
	// 	webkitMethod({
	// 		message: 'Hello from Frontend to Webkit!',
	// 		status: false,
	// 		count: 42,
	// 	}).then((response: any) => {
	// 		const endTime = performance.now();
	// 		console.log('Response from webkitMethod:', response);
	// 		console.log(`webkitMethod took ${endTime - startTime}ms`);
	// 	});
	// }, 10000);

	Millennium.AddWindowCreateHook(windowCreated);

	return {
		title: 'My Plugin',
		icon: <IconsModule.Settings />,
		content: <SettingsContent />,
	};
});
