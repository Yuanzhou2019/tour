import axios, { AxiosError, type AxiosInstance } from 'axios';
import type { ApiError } from '../types';

const http: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000/api/v1',
  timeout: 15_000,
  headers: { 'Content-Type': 'application/json' },
});

http.interceptors.request.use((config) => {
  const raw = localStorage.getItem('sightour-admin-auth');
  if (raw) {
    try {
      const parsed = JSON.parse(raw) as { state: { accessToken: string } };
      const token = parsed.state?.accessToken;
      if (token && config.headers) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    } catch {
      // ignore parse error
    }
  }
  return config;
});

http.interceptors.response.use(
  (response) => response,
  (error: AxiosError<ApiError>) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('sightour-admin-auth');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  },
);

export default http;
