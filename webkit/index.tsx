import { Millennium, callable } from '@steambrew/webkit';

const receiveFrontendMethod = callable<[{ message: string; status: boolean; count: number }], boolean>('Backend.receive_frontend_message');

function someWebkitMethod(message: string, status: boolean, count: number) {
	console.log(`Message: ${message}, Status: ${status}, Count: ${count}`);
	return 'method called from webkit';
}

Millennium.exposeObj({ someWebkitMethod });

export default async function WebkitMain() {
	const success = await receiveFrontendMethod({
		message: 'Hello World From Frontend!',
		status: true,
		count: 69,
	});

	console.log('Result from receive_frontend_message:', success);
}
