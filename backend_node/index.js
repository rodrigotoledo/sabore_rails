// Bot WhatsApp <-> MCP (Rails)
import pkg from 'whatsapp-web.js';
const { Client, LocalAuth } = pkg;
import qrcode from 'qrcode-terminal';
import fetch from 'node-fetch';

const MCP_BASE_URL = 'http://localhost:3000/mcp/resources'; // ajuste se necessário

const client = new Client({
    authStrategy: new LocalAuth()
});

client.on('qr', (qr) => {
    qrcode.generate(qr, { small: true });
    console.log('Escaneie o QR code acima com o WhatsApp!');
});

client.on('ready', () => {
    console.log('Bot WhatsApp-MCP está pronto!');
});

client.on('message', async msg => {
    const text = msg.body.toLowerCase();
    if (text.includes('prato') || text.includes('menu')) {
        // Exemplo: buscar menu_items do MCP
        try {
            const res = await fetch(`${MCP_BASE_URL}/menu_items`);
            const items = await res.json();
            if (Array.isArray(items) && items.length > 0) {
                const nomes = items.map(i => i.name).join(', ');
                await msg.reply(`Pratos disponíveis: ${nomes}`);
            } else {
                await msg.reply('Nenhum prato cadastrado no momento.');
            }
        } catch (e) {
            await msg.reply('Erro ao consultar o menu.');
        }
    } else {
        await msg.reply('Olá! Pergunte sobre o menu para ver os pratos disponíveis.');
    }
});

client.initialize();
