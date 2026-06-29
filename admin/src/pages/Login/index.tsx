import { App, Button, Card, Form, Input } from 'antd';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import http from '../../services/http';
import type { LoginResponse } from '../../types';
import { useState } from 'react';

interface LoginValues {
  username: string;
  password: string;
}

export default function LoginPage() {
  const navigate = useNavigate();
  const setAuth = useAuthStore((s) => s.setAuth);
  const { message } = App.useApp();
  const [loading, setLoading] = useState(false);

  const onFinish = async (values: LoginValues): Promise<void> => {
    setLoading(true);
    try {
      const res = await http.post<LoginResponse>('/auth/login', values);
      setAuth({
        user: res.data.user,
        accessToken: res.data.accessToken,
      });
      message.success('登录成功');
      navigate('/dashboard', { replace: true });
    } catch {
      message.error('用户名或密码错误');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: '#f0f2f5',
      }}
    >
      <Card title="Sightour 管理后台 · 登录" style={{ width: 360 }}>
        <Form<LoginValues> layout="vertical" onFinish={onFinish}>
          <Form.Item
            label="用户名"
            name="username"
            rules={[{ required: true, message: '请输入用户名' }]}
          >
            <Input autoComplete="username" />
          </Form.Item>
          <Form.Item
            label="密码"
            name="password"
            rules={[{ required: true, message: '请输入密码' }]}
          >
            <Input.Password autoComplete="current-password" />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block loading={loading}>
              登录
            </Button>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
}
