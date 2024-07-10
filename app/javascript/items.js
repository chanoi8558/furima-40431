function items (){
  
  const priceInput = document.querySelector("#item-price");
  const taxOutput = document.querySelector("#add-tax-price");
  const profitOutput = document.querySelector("#profit");

  if (priceInput) {
    priceInput.addEventListener("input", () => {
      const price = parseInt(priceInput.value);
            
      if (isNaN(price)) {
        taxOutput.innerHTML = '';
        profitOutput.innerHTML = '';
        return;
      }
      
      const fee = Math.floor(price * 0.1);
      const profit = price - fee;

      taxOutput.innerHTML = fee;
      profitOutput.innerHTML = profit;
    });
  }
};

window.addEventListener('turbo:load', items);