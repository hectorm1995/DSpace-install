# Iniciar con la instalación del BACKEND y luego del FRONTEND
## Los pasos a seguir estàn destinados para la versiòn DSPACE 7.5 en un servidor LINUX Ubuntu 22.04 64 bits
### Los Anexos muestran como deberìan ser los resultados en el caso de que todo el proceso se este realizando de manera correcta

...
cd /dspace/config/
sudo nano local.cfg
...

document.addEventListener('DOMContentLoaded', function () {
    const codeBlocks = document.querySelectorAll('pre > code');
    codeBlocks.forEach(function (codeBlock) {
        const button = document.createElement('button');
        button.className = 'copy-code-button';
        button.textContent = 'Copy code';
        button.addEventListener('click', function () {
            const code = codeBlock.textContent;
            navigator.clipboard.writeText(code).then(function () {
                button.textContent = 'Copied!';
                setTimeout(function () {
                    button.textContent = 'Copy code';
                }, 1500);
            }).catch(function (error) {
                console.error('Error copying code: ', error);
            });
        });
        codeBlock.parentNode.insertBefore(button, codeBlock);
    });
});
