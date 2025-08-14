import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VerificarFechaComponent } from './verificar-fecha.component';

describe('VerificarFechaComponent', () => {
  let component: VerificarFechaComponent;
  let fixture: ComponentFixture<VerificarFechaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [VerificarFechaComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(VerificarFechaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
