import Mux from '@mux/mux-node';
import { STREAM_MUX_TOKEN_ID, STREAM_MUX_TOKEN_SECRET } from '$env/static/private';

const mux = new Mux({
	tokenId: STREAM_MUX_TOKEN_ID,
	tokenSecret: STREAM_MUX_TOKEN_SECRET
});

export default mux;
