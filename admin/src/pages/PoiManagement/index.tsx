import { App, Button, Modal, Popconfirm, Space, Tag } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import type { Poi } from '../../types';
import PoiForm from './PoiForm';

const categoryLabels: Record<string, string> = {
  attraction: '景点',
  dining: '餐饮',
  lodging: '住宿',
  shopping: '购物',
};
const categoryColors: Record<string, string> = {
  attraction: 'blue',
  dining: 'orange',
  lodging: 'purple',
  shopping: 'green',
};

export default function PoiManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<Poi[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; poi?: Poi }>({ open: false });

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await http.get<{ data: Poi[] }>('/pois/search');
      setData(res.data.data);
    } catch {
      message.error('加载 POI 数据失败');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    try {
      await http.delete(`/pois/${id}`);
      message.success('已删除');
      fetchData();
    } catch {
      message.error('删除失败');
    }
  };

  const columns: ProColumns<Poi>[] = [
    { title: '中文名称', dataIndex: 'nameZh', key: 'nameZh', width: 180 },
    { title: '英文名称', dataIndex: 'nameEn', key: 'nameEn', width: 200 },
    { title: '城市', dataIndex: 'city', key: 'city', width: 80 },
    {
      title: '分类',
      dataIndex: 'category',
      key: 'category',
      width: 100,
      render: (_, r) => <Tag color={categoryColors[r.category]}>{categoryLabels[r.category]}</Tag>,
    },
    {
      title: '标签',
      dataIndex: 'tags',
      key: 'tags',
      width: 200,
      render: (_, r) =>
        r.tags?.map((t) => (
          <Tag key={t.id} color={t.category === 'positive' ? 'green' : t.category === 'warning' ? 'gold' : 'red'}>
            {t.labelZh}
          </Tag>
        )),
    },
    {
      title: '操作',
      key: 'action',
      width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => setEditModal({ open: true, poi: r })}>编辑</a>
          <Popconfirm title="确认删除此 POI？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<Poi>
        headerTitle="POI 管理"
        columns={columns}
        dataSource={data}
        loading={loading}
        rowKey="id"
        search={false}
        pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />} onClick={() => setEditModal({ open: true })}>
            新增 POI
          </Button>,
        ]}
      />
      <PoiForm
        open={editModal.open}
        poi={editModal.poi}
        onClose={() => setEditModal({ open: false })}
        onSuccess={() => {
          setEditModal({ open: false });
          fetchData();
        }}
      />
    </div>
  );
}
