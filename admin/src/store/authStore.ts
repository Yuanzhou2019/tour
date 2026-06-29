import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { AdminUser } from '../types';

export interface AuthData {
  user: AdminUser;
  accessToken: string;
}

interface AuthState {
  user: AdminUser | null;
  accessToken: string | null;
  isAuthed: boolean;
  setAuth: (data: AuthData) => void;
  clear: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      isAuthed: false,
      setAuth: ({ user, accessToken }: AuthData) =>
        set({ user, accessToken, isAuthed: true }),
      clear: () => set({ user: null, accessToken: null, isAuthed: false }),
    }),
    { name: 'sightour-admin-auth' },
  ),
);
