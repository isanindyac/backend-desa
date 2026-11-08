require('dotenv').config();
const express = require('express');
const pool = require('./db');
const app = express();
app.use(express.json());

// GET semua
app.get('/penduduk', async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM penduduk ORDER BY id');
    res.json(r.rows);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// GET by id
app.get('/penduduk/:id', async (req, res) => {
  try {
    const r = await pool.query('SELECT * FROM penduduk WHERE id=$1', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json(r.rows[0]);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// POST
app.post('/penduduk', async (req, res) => {
  const { desa_id, nik, nama, alamat, no_hp } = req.body;
  try {
    const r = await pool.query(
      'INSERT INTO penduduk (desa_id,nik,nama,alamat,no_hp) VALUES ($1,$2,$3,$4,$5) RETURNING *',
      [desa_id, nik, nama, alamat, no_hp]);
    res.status(201).json(r.rows[0]);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// PUT
app.put('/penduduk/:id', async (req, res) => {
  const { nik, nama, alamat, no_hp } = req.body;
  try {
    const r = await pool.query(
      'UPDATE penduduk SET nik=$1,nama=$2,alamat=$3,no_hp=$4 WHERE id=$5 RETURNING *',
      [nik, nama, alamat, no_hp, req.params.id]);
    if (!r.rows.length) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json(r.rows[0]);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

// DELETE
app.delete('/penduduk/:id', async (req, res) => {
  try {
    const r = await pool.query('DELETE FROM penduduk WHERE id=$1 RETURNING *', [req.params.id]);
    if (!r.rows.length) return res.status(404).json({ message: 'Data tidak ditemukan' });
    res.json({ message: 'Data berhasil dihapus', data: r.rows[0] });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.listen(process.env.PORT || 3000, () => console.log('Server jalan'));
