const apiBase = 'http://localhost:4000/api'
const uid = '1';

const defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
}

export default {
  async getToken() {
    const rawResponse = await fetch(`${apiBase}/users`, {
      method: 'POST',
      headers: defaultHeaders,
      body: JSON.stringify({uid}),
    });
    const response = await rawResponse.json();
    return response.data.token;
  },

  async getRooms(token: String) {
    const rawResponse = await fetch(`${apiBase}/admin/rooms`, {
      method: 'GET',
      headers: {
        ...defaultHeaders,
        'Authorization': `Bearer ${token}`
      },
    });
    const response = await rawResponse.json();
    return response.data;
  },

  async deleteRoom(token: String, roomId: String) {
    const rawResponse = await fetch(`${apiBase}/admin/rooms/${roomId}`, {
      method: 'DELETE',
      headers: {
        ...defaultHeaders,
        'Authorization': `Bearer ${token}`,
      },
    });
    return rawResponse;
  },

  async getMessages(token: String, roomId: String) {
    const now = new Date();
    const rawResponse = await fetch(`${apiBase}/rooms/${roomId}/messages?before=${now.toISOString()}&limit=500`, {
      method: 'GET',
      headers: {
        ...defaultHeaders,
        'Authorization': `Bearer ${token}`,
      },
    });

    const response = await rawResponse.json();
    return response.data;
  },
};