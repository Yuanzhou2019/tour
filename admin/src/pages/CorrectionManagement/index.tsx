import { App, Button, Space, Tag } from 'antd';
import { CheckOutlined, CloseOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import type { Correction } from '../../types';

const typeLabels: Record<string, string> = {
  content_error: '内容错误', policy: '政策', poi: 'POI', phrase: '常用语', other: '其他',
};
const statusLabels: Record<string, string> = {
  queued: '待处理', reviewing: '审核中', resolved: '已解决', rejected: '已驳回',
};
const statusColors: Record<string, string> = {
  queued: 'blue', reviewing: 'orange', resolved: 'green', rejected: 'red',
};

export default function CorrectionManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<Correction[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await http.get<{ data: Correction[] }>('/corrections');
      setData(res.data.data);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleStatus = async (id: string, status: 'reviewing' | 'resolved' | 'rejected') => {
    try {
      await http.patch(`/corrections/${id}`, { status });
      message.success('状态已更新');
      fetchData();
    } catch { message.error('更新失败'); }
  };

  const columns: ProColumns<Correction>[] = [
    { title: '类型', dataIndex: 'type', key: 'type', width: 100, render: (_, r) => typeLabels[r.type] },
    { title: '内容', dataIndex: 'message', key: 'message', width: 300, ellipsis: true },
    { title: '状态', dataIndex: 'status', key: 'status', width: 80,
      render: (_, r) => <Tag color={statusColors[r.status]}>{statusLabels[r.status]}</Tag> },
    { title: '联系方式', dataIndex: 'contactEmail', key: 'contactEmail', width: 180 },
    { title: '提交时间', dataIndex: 'createdAt', key: 'createdAt', width: 160,
      render: (_, r) => new Date(r.createdAt).toLocaleString() },
    { title: '操作', key: 'action', width: 200,
      render: (_, r) => (
        <Space>
          {r.status === 'queued' && (
            <Button size="small" onClick={() => handleStatus(r.id, 'reviewing')}>开始审核</Button>
          )}
          {r.status === 'reviewing' && (
            <>
              <Button size="small" type="primary" icon={<CheckOutlined />}
                onClick={() => handleStatus(r.id, 'resolved')}>采纳</Button>
              <Button size="small" danger icon={<CloseOutlined />}
                onClick={() => handleStatus(r.id, 'rejected')}>驳回</Button>
            </>
          )}
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<Correction> headerTitle="纠错审核"
        columns={columns} dataSource={data} loading={loading} rowKey="id"
        search={false} pagination={{ pageSize: 20 }}
      />
    </div>
  );
}
