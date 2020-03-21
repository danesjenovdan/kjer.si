const getHeaders = token => ({ 'Content-Type': 'application/json', Authorization: `Bearer ${token}` })

export async function fetchUsers(token) {
  const users = await window.fetch('/api/admin/users', { headers: getHeaders(token) })
  return await users.json()
}

export async function toggleUserActive(user, token) {
  await window.fetch(`/api/admin/users/${user.id}`, {
    headers: getHeaders(token),
    method: 'PUT',
    body: JSON.stringify({
      user: {
        is_active: !user.is_active
      }
    })
  })
}

export async function fetchRooms(token) {
  const rooms = await window.fetch('/api/admin/rooms', { headers: getHeaders(token) })
  return await rooms.json()
}

export async function deleteRoom(room, token) {
  await window.fetch(`/api/admin/rooms/${room.id}`, {
    headers: getHeaders(token),
    method: 'DELETE'
  })
}
